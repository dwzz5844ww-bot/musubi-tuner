import logging


def configure_scm_logging() -> None:
    """Apply SCM-specific logging cleanup without hiding meaningful warnings."""

    # PyTorch emits this warning during Diffusers/TorchDynamo import even when
    # Triton is not needed for the active workflow.
    logging.getLogger("torch.utils.flop_counter").setLevel(logging.ERROR)