# Contributing

Contributions to the package are welcome, please read the guidelines and ground rules before contributing.

## Ground Rules

1. For contributions to the `.wl` before commiting, please format your code using the Wolfram lamnguage formatter (paclet "CodeFormatter").
2. For contributions to the `.nb` files, please start a fresh kernel and run the entire notebook before commiting. The notebook should run without errors.

## Commits

I am using a single trunk. This means that you should rebase your work to a single commit before submitting a pull request. This is to keep the history clean and easy to follow. Besides this, the following rules apply:

1. A commit should do one atomic change on the repository
2. The commit message should be descriptive.
3. Use the body to explain what and why vs. how
4. Please mention what was wrong with the previous implementation, if applicable.

## Pull Request Process

1. Fork the main repo
2. Start a dev branch from the main branch within your fork
3. Do some cool stuff
4. Pull the latest changes from the main repo
5. Rebase your work to a single commit (`git rebase -i`)
6. Push your commit
7. Make a pull request and ask for a review using the @ symbol
