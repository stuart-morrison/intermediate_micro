# Makefile for converting R Markdown files to PDF
# Handles filenames with spaces properly

# Default target
all: lectures discussions exams

# Build all lecture slides
lectures:
	@echo "Building lecture slides..."
	@sh -c ' \
		find lecture_slides -name "*.Rmd" -type f | while read -r file; do \
			pdf_file="$${file%.Rmd}.pdf"; \
			if [ ! -f "$$pdf_file" ] || [ "$$file" -nt "$$pdf_file" ]; then \
				echo "Building: $$file"; \
				R -e "pagedown::chrome_print(\"$$file\")" --slave; \
			else \
				echo "Up to date: $$pdf_file"; \
			fi; \
		done'
	@$(MAKE) clean-aux

# Build all discussion questions
discussions:
	@echo "Building discussion questions..."
	@sh -c ' \
		find discussion_questions -name "*.Rmd" -type f | while read -r file; do \
			pdf_file="$${file%.Rmd}.pdf"; \
			if [ ! -f "$$pdf_file" ] || [ "$$file" -nt "$$pdf_file" ]; then \
				echo "Building: $$file"; \
				R -e "rmarkdown::render(\"$$file\", output_format = \"pdf_document\")" --slave; \
			else \
				echo "Up to date: $$pdf_file"; \
			fi; \
		done'
	@$(MAKE) clean-aux

# Build all discussion questions
exams:
	@echo "Building exams..."
	@sh -c ' \
		find exams -name "*.Rmd" -type f | while read -r file; do \
			pdf_file="$${file%.Rmd}.pdf"; \
			if [ ! -f "$$pdf_file" ] || [ "$$file" -nt "$$pdf_file" ]; then \
				echo "Building: $$file"; \
				R -e "rmarkdown::render(\"$$file\", output_format = \"pdf_document\")" --slave; \
			else \
				echo "Up to date: $$pdf_file"; \
			fi; \
		done'
	@$(MAKE) clean-aux


# Clean up generated PDFs
clean:
	find lecture_slides -name "*.pdf" -type f -delete
	find discussion_questions -name "*.pdf" -type f -delete
	find exams -name "*.pdf" -type f -delete

# Clean up LaTeX auxiliary files
clean-aux:
	@echo "Cleaning LaTeX auxiliary files..."
	@find lecture_slides discussion_questions ./ \( \
		-name "*.html" -o \
		-name "*.aux" -o \
		-name "*.bbl" -o \
		-name "*.bcf" -o \
		-name "*.blg" -o \
		-name "*.fdb_latexmk" -o \
		-name "*.fls" -o \
		-name "*.log" -o \
		-name "*.run.xml" -o \
		-name "*.xdv" \
	\) -type f -delete 2>/dev/null || true

# Clean up everything (PDFs and auxiliary files)
clean-all: clean clean-aux

# List all source files (useful for debugging)
list:
	@echo "Lecture files:"
	@find lecture_slides -name "*.Rmd" -type f
	@echo "Discussion files:"
	@find discussion_questions -name "*.Rmd" -type f
	@echo "Exams:"
	@find exams -name "*.Rmd" -type f

# Force rebuild everything
rebuild: clean-all all

# Declare phony targets
.PHONY: all lectures discussions exams clean clean-aux clean-all list rebuild