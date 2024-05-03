
<a href="https://github.com/gpap-gpap/SymbolicAnisotropy">
<img align="Right" src="images/logo.png" width="100%"/>
</a>

# Symbolic Anisotropy

A Wolfram Language package for symbolic calculations in anisotropic elasticity. The package provides tools for the manipulation of elastic tensors of arbitrary symmetry, the calculation of Christoffel tensors, phase velocities, polarization vectors, and reflection and transmission coefficients. The package is designed to be used in the context of seismology, geophysics, and materials science.

## Requirements

_Mathematica >13.1_

## Installation

`<< "https://raw.githubusercontent.com/gpap-gpap/SymbolicAnisotropy/main/SymbolicAnisotropy.wl"`

## Features

- Elastic tensors of arbitrary symmetry:
`saCreateElasticityTensor[c  , "Symmetry" -> "Monoclinic"] //saConvert[c, #] &`
$\begin{bmatrix}
 \text{c}_{11} & \text{c}_{12} & \text{c}_{13} & 0 & 0 & \text{c}_{16} \\
 \text{c}_{12} & \text{c}_{22} & \text{c}_{23} & 0 & 0 & \text{c}_{62} \\
 \text{c}_{13} & \text{c}_{23} & \text{c}_{33} & 0 & 0 & \text{c}_{63} \\
 0 & 0 & 0 & \text{c}_{44} & \text{c}_{54} & 0 \\
 0 & 0 & 0 & \text{c}_{54} & \text{c}_{55} & 0 \\
 \text{c}_{16} & \text{c}_{62} & \text{c}_{63} & 0 & 0 & \text{c}_{66} \\\\\end{bmatrix}$
- Rotation and translation transformations for tilt
- Christoffel tensor and calculations
- Phase velocities and polarization vectors:
<img src="images/animatied_slowness.gif" width="400"/>
- Reflection and transmission coefficients

## Roadmap

- [ ] Group Velocities
- [ ] Slowness Surfaces
- [ ] Ray tracing
- [ ] NMO analysis

## Maintenance and feedback

<giorgos.papageorgiou@ed.ac.uk>

## References

1. Musgrave, M. J. P. (1970). _Crystal acoustics: Introduction to the study of elastic waves and vibrations in crystals_. Holden-Day, San Francisco

2. Nye, J. F. (1985). Physical properties of crystals: their representation by tensors and matrices. Oxford university press.
3. Tsvankin, I. (2012). _Seismic signatures and analysis of reflection data in anisotropic media_. Society of Exploration Geophysicists.
4. _Structural mechanics MIT lecture notes_, <https://web.mit.edu/16.20/homepage/>
5. Helbig, K. (2015). _Foundations of Anisotropy for Exploration Seismics: Section I. Seismic Exploration_. Elsevier.

![License](https://img.shields.io/badge/License-MIT-blue.svg)
