docker run repronim/neurodocker:0.7.0 \
	generate docker --base ubuntu \
	--pkg-manager=apt --install apt-utils \
	ca-certificates curl git locales r-base r-cran-devtools \
	--miniconda conda_install="python=3.7 numpy pandas statsmodels" \
	create_env="harmonization" activate=true \
	--copy "./R_config.sh" . \
	-r "./R_config.sh" \
	--add-to-entrypoint "/input/harmonize_cmd.sh" \
	> Dockerfile
