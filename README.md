# Alokopeace_1639

This repository is a multi-project Flutter workspace. It currently contains three separate app projects that should be organized and tracked clearly.

## Repository structure

```text
Alokopeace_1639/
├── README.md
├── .gitignore
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── lib/
├── android/
├── web/
├── windows/
├── test/
├── Screen_1/                  # Project 2: workshop screen prototype
├── flutter_application_1/     # Project 3: initial Flutter app
├── projects/
│   ├── README.md
│   ├── farm_app/
│   │   └── README.md
│   ├── screen_1/
│   │   └── README.md
│   └── flutter_application_1/
│       └── README.md
└── docs/
    └── repo-organization.md
```

## Project list

1. Farm App (active project in the root folder)
   - Main Flutter app
   - Source files live in the repository root (`lib/`, `android/`, etc.)

2. Screen_1
   - Separate prototype project kept in `Screen_1/`

3. flutter_application_1
   - Separate starter project kept in `flutter_application_1/`

## Recommended workflow

- Keep the repository root as the main `farm_app` project
- Keep the other two projects as isolated folders under `Screen_1/` and `flutter_application_1/`
- Use the `projects/` folder as the canonical index for documentation and future migration
- Avoid mixing Flutter app files from different projects at the same root level

## Next step

Once the project boundaries are confirmed, we can fully migrate each project into its own isolated folder and keep the root cleaner. The current layout is already organized enough to separate the three apps without losing any source code.
