run:
	@if [ -z "$(file)" ]; then \
		echo "Usage: make run file=path/to/your/file.dtr"; \
  		exit 1; \
  fi; \
	./digicus_web_frontend $(file)

version:
	@./digicus_web_frontend version