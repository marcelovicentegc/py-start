EXPECTED_MIN_VERSION="$1" || "36"

HAS_PYTHON=$(hash python)
HAS_PYTHON3=$(hash python3)

create_cmd_alias() {
  if $($HAS_PYTHON3)
  then
    py="python3"
    pip="pip3"
  else 
    py="python"
  fi
}

create_venv() {
  if $($HAS_PYTHON3)
  then
    py="python3"
    pip="pip3"
  else 
    py="python"
  fi

  $py --version
  $py -m venv venv
  echo "Virtual environment successfully created.\nEntering virtual environment..."
  source venv/bin/activate
  echo "Virtual environment activated.\nInstalling dependencies..."
  $pip install -r requirements.txt
  echo "Successfully installed dependencies."

  unset py pip
}

venv_lookup() {  
  VENV_DIR="./venv"

  if [[ -d "$VENV_DIR" ]]
  then
    echo "Virtual environment already exists."
  else
    echo "Virtual environment doesn't exists. Creating one..."
    create_venv
  fi

  unset VENV_DIR
} 

if $(! $HAS_PYTHON) && $(! $HAS_PYTHON3); then
    echo "Make sure you have Python installed"
    exit 1
fi

create_cmd_alias

if $HAS_PYTHON3; then
  PYTHON_VERSION=$($py -V 2>&1 | sed 's/.* \([0-9]\).\([0-9]\).*/\1\2/')

  if [[ "$PYTHON_VERSION" -lt "$EXPECTED_MIN_VERSION" ]]; then
    echo "This library requires Python ${EXPECTED_MIN_VERSION:0:${#EXPECTED_MIN_VERSION}/2}.${EXPECTED_MIN_VERSION:${#EXPECTED_MIN_VERSION}/2} and above"
    exit 1
  fi

  venv_lookup
fi

unset EXPECTED_MIN_VERSION HAS_PYTHON HAS_PYTHON3