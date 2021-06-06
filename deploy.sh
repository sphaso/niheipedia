# Temporarily store uncommited changes
git stash

# Verify correct branch
git checkout dev

# Build new files
stack exec site clean
stack exec site build

# Get previous files
git fetch --all
git checkout -b main --track origin/main

# Overwrite existing files with new files
cp -a _site/. .

# Commit
git add -A
git commit -m "Publish."

# Push
git push origin main:main

# Restoration
git checkout dev
git branch -D main
git stash pop
