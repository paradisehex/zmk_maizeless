zmk_src_dir=$(HOME)/src/zmk
board=nice_nano_v2
shield=maizeless
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

mount_path=/run/media/$(USER)/NICENANO/

build:
	cd $(zmk_src_dir)/app && \
		west build --pristine -d build/left -b $(board) -- -DSHIELD=$(shield)_left -DZMK_CONFIG="$(mkfile_dir)" && \
		west build -d build/right -b $(board) -- -DSHIELD=$(shield)_right -DZMK_CONFIG="$(mkfile_dir)"

build_left:
	cd $(zmk_src_dir)/app && \
		west build --pristine -d build/left -b $(board) -- -DSHIELD=$(shield)_left -DZMK_CONFIG="$(mkfile_dir)"

build_right:
	cd $(zmk_src_dir)/app && \
		west build --pristine -d build/right -b $(board) -- -DSHIELD=$(shield)_right -DZMK_CONFIG="$(mkfile_dir)"

build_reset:

	
flash_left:
	cp $(zmk_src_dir)/app/build/left/zephyr/zmk.uf2 $(mount_path)
flash_right:
	cp $(zmk_src_dir)/app/build/right/zephyr/zmk.uf2 $(mount_path)

