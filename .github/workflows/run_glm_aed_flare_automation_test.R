on:
  workflow_dispatch:
  #schedule:
  # - cron: "0 13 * * *"

name: glm_aed_flare_v3

jobs:
  run_flare:
    runs-on: ubuntu-latest #[self-hosted]
    env:
      GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
      MW_ACCESS_KEY_ID: ${{ secrets.MW_ACCESS_KEY_ID }}
      MW_ACCESS_SECRET: ${{ secrets.MW_ACCESS_SECRET }}
    permissions:
     contents: write
    container: rqthomas/flare-rocker:4.4
    steps:
      - uses: actions/checkout@v6

      - name: clone lake repository
        uses: actions/checkout@v6
        with:
          repository: ecoforecastVT/YARR-forecast
          token: ${{ secrets.GIT_PAT }}
          path: forecast-code

      - name: install deps
        env:
          GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
        shell: Rscript {0}
        run: |
          remotes::install_github('LTREB-reservoirs/ver4castHelpers')
          install.packages('rLakeAnalyzer')

# Point to the right path, run the right Rscript command
      - name: Run automatic prediction file
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.MW_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.MW_ACCESS_SECRET }}
          GITHUB_PAT: ${{ secrets.GITHUB_TOKEN }}
        run:  Rscript $GITHUB_WORKSPACE/forecast-code/workflows/glm_aed_flare_automation_test/forecast_workflow_aed.R
