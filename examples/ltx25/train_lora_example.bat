@echo off
setlocal

set MUSUBI=C:\Path_To_musubi-ltx_Folder\musubi-ltx
set DATASET=C:\Path_To_Training_Folder\config\config_example.toml

set LTX_MODEL=C:\Path_To_Models_Folder\diffusion_models\ltx-2.5-22b-dev-transformer-bf16.safetensors

set OUTPUT=C:\Path_To_Training_Folder\output


REM ============================================================
REM LoRA target preset
REM
REM t2v  = Attention projections only (Q/K/V/Out).
REM        Musubi default. Smaller/narrower adaptation.
REM
REM v2v  = Attention + video/audio FFN layers.
REM        Chosen for Character identity LoRA because intended use
REM        includes T2V, I2V, FLF2V/keyframe/reference workflows
REM        in LTX Desktop and ComfyUI.
REM
REM full = All matching Linear layers.
REM        Broadest adaptation. NOT selected for initial training.
REM        Re-evaluate with larger dataset / VRAM requirements.
REM ============================================================
set LORA_PRESET=t2v

echo.
echo ============================================================
echo LTX 2.5 LORA TRAINING
echo ============================================================
echo MUSUBI  = %MUSUBI%
echo DATASET = %DATASET%
echo MODEL   = %LTX_MODEL%
echo OUTPUT  = %OUTPUT%
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

if not exist "%OUTPUT%" (
    mkdir "%OUTPUT%"
)

call "%MUSUBI%\venv-ltx25-upstream\Scripts\activate.bat"

cd /d "%MUSUBI%"

REM ============================================================
REM FULL TRAINING CONFIGURATION
REM max_train_steps = 2000
REM output_name = Example_LoRA_LTX25
REM
REM IMPORTANT:
REM Do NOT insert REM comments inside the multi-line command below.
REM CMD line continuation using ^ can interact badly with REM lines.
REM Ask us how we know. :)
REM ============================================================

accelerate launch ^
  --num_cpu_threads_per_process 1 ^
  --mixed_precision bf16 ^
  --module musubi_tuner.ltx2_train_network ^
  --dataset_config "%DATASET%" ^
  --ltx2_checkpoint "%LTX_MODEL%" ^
  --ltx_version 2.5 ^
  --ltx_version_check_mode error ^
  --ltx2_mode video ^
  --mixed_precision bf16 ^
  --nf4_base ^
  --quantize_device cuda ^
  --gradient_checkpointing ^
  --blocks_to_swap 12 ^
  --ltx2_low_ram_load ^
  --sdpa ^
  --network_module networks.lora_ltx2 ^
  --lora_target_preset %LORA_PRESET% ^
  --network_dim 64 ^
  --network_alpha 64 ^
  --optimizer_type AdamW ^
  --learning_rate 1e-4 ^
  --timestep_sampling shifted_logit_normal ^
  --max_train_steps 2000 ^
  --save_every_n_epochs 1 ^
  --save_last_n_epochs 3 ^
  --output_dir "%OUTPUT%" ^
  --output_name "Example_LoRA_LTX25"

if errorlevel 1 (
    echo.
    echo ============================================================
    echo TRAINING FAILED
    echo ============================================================
    pause
    exit /b 1
)

echo.
echo ============================================================
echo TRAINING COMPLETE
echo ============================================================

pause