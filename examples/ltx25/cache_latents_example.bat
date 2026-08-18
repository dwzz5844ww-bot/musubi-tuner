@echo off
setlocal

set MUSUBI=C:\Path_To_musubi-ltx_Folder\musubi-ltx
set DATASET=C:\Path_To_Training_Folder\config\config_example.toml

set LTX_MODEL=C:\Path_To_Models_Folder\diffusion_models\ltx-2.5-22b-dev-transformer-bf16.safetensors

set VIDEO_VAE=C:\Path_To_Models_Folder\vae\ltx-2.5-video-vae-bf16.safetensors

echo.
echo ============================================================
echo YOUR LoRA NAME HERE - LTX 2.5 LATENT CACHE
echo ============================================================
echo MUSUBI    = %MUSUBI%
echo DATASET   = %DATASET%
echo MODEL     = %LTX_MODEL%
echo VIDEO VAE = %VIDEO_VAE%
echo ============================================================
echo.

if not exist "%MUSUBI%" (
    echo ERROR: Musubi directory not found.
    pause
    exit /b 1
)

if not exist "%DATASET%" (
    echo ERROR: Dataset config not found.
    pause
    exit /b 1
)

if not exist "%LTX_MODEL%" (
    echo ERROR: LTX 2.5 transformer not found.
    pause
    exit /b 1
)

if not exist "%VIDEO_VAE%" (
    echo ERROR: LTX 2.5 Video VAE not found.
    pause
    exit /b 1
)


REM ============================================================
REM Activate validated SCM environment
REM Python 3.14.7
REM PyTorch 2.13.0+cu130 / CUDA 13.0
REM Musubi Tuner 0.3.4+scm.1
REM ============================================================

call "%MUSUBI%\venv-ltx25-upstream\Scripts\activate.bat"

if errorlevel 1 (
    echo ERROR: Failed to activate venv-ltx25-upstream.
    pause
    exit /b 1
)

cd /d "%MUSUBI%"

echo Python environment:
python --version
echo.

python -m musubi_tuner.ltx2_cache_latents ^
  --dataset_config "%DATASET%" ^
  --vae "%VIDEO_VAE%" ^
  --vae_dtype bf16 ^
  --device cuda ^
  --ltx2_mode video ^
  --ltx_version 2.5

if errorlevel 1 (
    echo.
    echo ============================================================
    echo LATENT CACHE FAILED
    echo ============================================================
    pause
    exit /b 1
)

echo.
echo ============================================================
echo LATENT CACHE COMPLETE
echo ============================================================

pause