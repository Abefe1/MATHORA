import os
from dotenv import load_dotenv

load_dotenv()


def _require(name: str) -> str:
    value = os.environ.get(name)
    if not value:
        raise RuntimeError(f"Missing required env var: {name}")
    return value


class Settings:
    supabase_url: str = _require("SUPABASE_URL")
    supabase_service_role_key: str = _require("SUPABASE_SERVICE_ROLE_KEY")
    worker_shared_secret: str = _require("WORKER_SHARED_SECRET")

    llm_base_url: str = _require("LLM_BASE_URL")
    llm_api_key: str = _require("LLM_API_KEY")
    llm_model: str = _require("LLM_MODEL")

    # Optional — vision fallback is skipped (not an error) if unset.
    vision_llm_model: str | None = os.environ.get("VISION_LLM_MODEL") or None


settings = Settings()
