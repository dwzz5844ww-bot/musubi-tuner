@echo off
setlocal

set MUSUBI=C:\Path_To_musubi-ltx_Folder\musubi-ltx
set DATASET=C:\Path_To_Training_Folder\config\config_example.toml

set LTX_MODEL=C:\Path_To_Models_Folder\diffusion_models\ltx-2.5-22b-dev-transformer-bf16.safetensors
set GEMMA=C:\Path_To_Models_Folder\text_encoders\gemma4-12b-with-proj-ltx-2.5-bf16.safetensors

echo.
echo ============================================================
echo YOUR LoRA NAME HERE - LTX 2.5 TEXT CACHE
echo ============================================================
echo MUSUBI  = %MUSUBI%
echo DATASET = %DATASET%
echo MODEL   = %LTX_MODEL%
echo GEMMA   = %GEMMA%
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

if not exist "%GEMMA%" (
    echo ERROR: Gemma 4 LTX 2.5 text encoder not found.
    pause
    exit /b 1
)

REM ============================================================
REM Activate validated SCM environment
REM Python 3.14.7
REM PyTorch 2.13.0+cu130 / CUDA 13.0
REM Transformers 5.15.0
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

python -m musubi_tuner.ltx2_cache_text_encoder_outputs ^
  --dataset_config "%DATASET%" ^
  --ltx2_checkpoint "%LTX_MODEL%" ^
  --ltx2_text_encoder_checkpoint "%GEMMA%" ^
  --gemma_safetensors "%GEMMA%" ^
  --ltx2_mode video ^
  --ltx_version 2.5 ^
  --mixed_precision bf16 ^
  --device cuda

if errorlevel 1 (
    echo.
    echo ============================================================
    echo TEXT CACHE FAILED
    echo ============================================================
    pause
    exit /b 1
)

echo.
echo ============================================================
echo TEXT CACHE COMPLETE
echo ============================================================

pause