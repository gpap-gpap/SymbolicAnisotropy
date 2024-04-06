(* ::Package:: *)

BeginPackage["SymbolicAnisotropy`"];

GeneralUtilities`SetUsage[SymbolicAnisotropy`saReflectionTransformation,
     "saReflectionTransformation[vec$] returns a rank-8 tensor derived from 4 copies of a reflection transform along three dimensional vector vec$"
    ];

GeneralUtilities`SetUsage[SymbolicAnisotropy`saRotationTransformation,
     "saRotationTransformation[ang$, vec$] returns a rank-8 tensor derived from 4 copies of a rotation transform of angle ang$ around three dimensional vector vec$"
    ];

GeneralUtilities`SetUsage[SymbolicAnisotropy`saCreateElasticityTensor,
     "saCreateElasticityTensor[head$] returns a rank-4 elastic tensor with 21 independent components of the form head$[i, j, k, l].
saCreateElasticityTensor[head$, 'Symmetry'->$$] returns a rank-4 elastic tensor with additional symmetries as follows:
| Name | 'Monoclinic' | 'Orthotropic' | 'Transverse Isotropic' | 'Isotropic' |
| Independent Components | 13 | 9 | 5 | 2 |
| Symmetry type | Reflection | Reflection | Rotation | Rotation|
| Symmetry axis | {0,0,1} | {0,0,1} and {1,0,0} | {0,0,1} | {0,0,1} and{1,0,0} |
"
    ];

saCreateElasticityTensor::unknownSymmetry = "`1` is not one of known symmetry specifications: `2`.";

GeneralUtilities`SetUsage[SymbolicAnisotropy`saContract, "saContract[symmetry$, tensor$] provides the contraction of a rank-8 symmetry tensor, with a rank-4 elastic tensor.
saContract[saRotationTransformation[\[Theta], {1,0,0}], saCreateElasticityTensor[c, 'Symmetry'->'Transverse Isotropic']] tilts the symmetry plane of a VTI elastic tensor by \[Theta]
"
    ];

saTensor2Voigt::usage = "saTensor2Voigt[head] ...";

saVoigt2Tensor::usage = "saVoigt2Tensor[head] ...";

saVoigtReplacementRule::usage = "";

saTensorReplacementRule::usage = "";

saBondMatrix::usage = "saBondMatrix[head] ...";

saHumanReadable::usage = "saHumanReadable[head] ...";

saChristoffelMatrix::usage = "saChristoffelEquation[head] ...";

saPhaseVelocity::usage = "saPhaseVelocity[head] ...";

saGroupVelocity::usage = "saGroupVelocity[head] ...";

Begin["`Private`"]

voigtTable = {{1, 6, 5}, {6, 2, 4}, {5, 4, 3}}

saReflectionTransformation[v_] :=
    With[{r = ReflectionMatrix @ v},
        r \[TensorProduct] r \[TensorProduct] r \[TensorProduct] r
    ]

saRotationTransformation[\[Theta]_, v_] :=
    With[{r = RotationMatrix[\[Theta], v]},
        r \[TensorProduct] r \[TensorProduct] r \[TensorProduct] r
    ]

saContract[symmetry_, tensor_] :=
    TensorContract[symmetry \[TensorProduct] tensor, {{2, 9}, {4, 10},
         {6, 11}, {8, 12}}]

symmetrize[tens_, symm_] :=
    tens /. First @ Quiet[Solve[tens == saContract[symm, tens], DeleteDuplicates
         @ Cases[Flatten @ tens, _dummy]], Solve::svars]

symmetric @ "Generic" = Array[dummy, {3, 3, 3, 3}] /. dummy[a_, b_, d_,
     e_] /; d > e :> dummy[a, b, e, d] /. dummy[a_, b_, d_, e_] /; a > b :>
     dummy[b, a, d, e] /. dummy[a_, b_, d_, e_] /; ((a > d && b >= e) || 
    (a >= d && b > e) || (a > d && b < e)) :> dummy[d, e, a, b];

symmetric @ "Monoclinic" = symmetrize[symmetric @ "Generic", saReflectionTransformation
     @ {0, 0, 1}];

symmetric @ "Orthotropic" = symmetrize[symmetric @ "Monoclinic", saReflectionTransformation
     @ {1, 0, 0}];

symmetric @ "Transverse Isotropic" = symmetrize[symmetric @ "Orthotropic",
     saRotationTransformation[\[Pi] / 4, {0, 0, 1}]];

symmetric @ "Isotropic" = symmetrize[symmetric @ "Transverse Isotropic",
     saRotationTransformation[\[Pi] / 4, {1, 0, 0}]];

symmetric @ sym_ :=
    (
        Message[CreateElasticityTensor::unknownSymmetry, sym, Cases[DownValues
             @ symmetric, (_ @ _ @ s_String :> _) :> s]];
        $Failed
    )

Options[saCreateElasticityTensor] = {"Symmetry" -> "Generic"};

saCreateElasticityTensor[head_, OptionsPattern[]] :=
    symmetric @ OptionValue @ "Symmetry" /. dummy -> head

saBondMatrix[a_] :=
    ArrayFlatten[
        With[{symbol = a},
            With[{mat = Array[symbol, {3, 3}]},
                Module[{strageDet},
                    strangeDet[i_, j_] := {{{Mod[i + 1, 3], Mod[j + 1,
                         3]}, {Mod[i + 2, 3], Mod[j + 2, 3]}}, {{Mod[i + 2, 3], Mod[j + 1, 3]
                        }, {Mod[i + 1, 3], Mod[j + 2, 3]}}} /. (0 -> 3);
                    {
                        {
                            mat^2(*upper left hand block - square of 3x3 matrix
                                
                                
                                
                                
                                *),
                            2 RotateLeft /@ mat RotateRight /@ mat(*upper right hand block - 2x product of complementary rows
                                
                                
                                
                                
                                *)
                        }
                        ,
                        {
                            RotateLeft @ mat RotateRight @ mat (*lower left hand block - product of complementary columns
                                
                                
                                
                                
                                *) ,
                            Array[Plus @@ Times @@@ Apply[symbol, strangeDet[
                                ##], {2}]&, {3, 3}](*lower right hand block - weird vector product of submatrices
                                
                                
                                
                                *)
                        }
                    }
                ]
            ]
        ]
    ]

saVoigtReplacementRule[symbol_] :=
    With[{ip = voigtTable},
        symbol[Global`a_, Global`b_, Global`c_, Global`d_] :> (symbol[
            ip[[Global`a, Global`b]], ip[[Global`c, Global`d]]])
    ];

saTensorReplacementRule[symbol_] :=
    With[{ip = voigtTable},
        symbol[Global`a_, Global`b_] :> (symbol[Sequence @@ First @ Position[
            ip, Global`a], Sequence @@ First @ Position[ip, Global`b]])
    ];

saTensor2Voigt[symbol_, tensor_] /; Dimensions[tensor] === {3, 3, 3, 
    3} :=
    Module[{ip = voigtTable, table},
        table = (Table[tensor[[Sequence @@ First @ Position[ip, i], Sequence
             @@ First @ Position[ip, j]]], {i, 6}, {j, 6}]);
        table /. saVoigtReplacementRule[symbol]
    ];

saVoigt2Tensor[symbol_, matrix_] /; Dimensions[matrix] === {6, 6} :=
    Module[{ip = voigtTable, table},
        table = (Table[matrix[[ip[[i, j]], ip[[k, l]]]], {i, 3}, {j, 
            3}, {k, 3}, {l, 3}]);
        Transpose[table, {1, 2, 3}] /. saTensorReplacementRule[symbol
            ]
    ];

saHumanReadable[head_, expression_] :=
    expression /. head[a__] :> ToExpression[(ToString[head] <> (ToString
         /@ {a}))];

saChristoffelMatrix[c_, n_] /; Dimensions[c] === {3, 3, 3, 3} && Dimensions[
    n] === {3} :=
    TensorContract[c \[TensorProduct] n \[TensorProduct] n, {{2, 5}, 
        {4, 6}}];

End[];

EndPackage[];
