zmk_src_dir=$(HOME)/src/zmk
board=nice_nano_v2
shield=maizeless
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))
external_modules_list := "$(zmk_src_dir)/modules/zmk-num-word"
EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
COMMA := ,
external_modules = $(subst $(SPACE),$(COMMA),$(external_modules_list))

mount_path=/run/media/$(USER)/NICENANO/

.PHONY: build build_fresh build_left build_right build_reset

# Define functions to call west build with common parameters
define west_build
	cd $(zmk_src_dir)/app && \
		west build $(1) $(2) $(3) $(4) $(5) $(6) $(7) $(8) $(9) $(10) $(11) $(12) $(13) $(14) $(15) $(16) $(17) $(18) $(19) $(20)

endef

# $(1) = side
# $(2) = extra west arg
# $(3) = extra west arg
define west_build_main
	$(call west_build,-d,build/$(1),-b,$(board),$(2),$(3),--,\
		-DSHIELD=$(shield)_$(1),-DZMK_CONFIG="$(mkfile_dir)",-DZMK_EXTRA_MODULES=$(external_modules))
endef

define west_build_simple
	$(call west_build,-d,build/$(1),-b,$(board))
endef

	# cd $(zmk_src_dir)/app && \
	# 	west build -d build/left -b $(board) && \
	# 	west build -d build/right -b $(board)

# Default build target for both left and right
build:
	$(call west_build_simple,left)
	$(call west_build_simple,right)

# Build only one side
build_left:
	$(call west_build_main,left)
build_right:
	$(call west_build_main,right)

# Build with --pristine for both left and right
build_fresh:
	$(call west_build_main,left,--pristine)
	$(call west_build_main,right,--pristine)

build_reset:
	$(call west_build,--pristine,-d,build/settings_reset,-b,$(board),--,-DSHIELD=settings_reset)

flash_reset:
	cp $(zmk_src_dir)/app/build/zephyr/zmk.uf2 $(mount_path)

layer_drawing = maizeless_keymap.mine.pdf
# Draw layers using keymap-drawer
draw: $(layer_drawing)

$(layer_drawing): keymap_drawer.yaml
	keymap draw --qmk-keyboard corne_rotated $< >| $@.svg
	inkscape --export-pdf=$@ $@.svg

keymap_drawer.yaml: maizeless.keymap
	keymap parse -c 10 -z $< >| $@
	
flash_left:
	cp $(zmk_src_dir)/app/build/left/zephyr/zmk.uf2 $(mount_path)
flash_right:
	cp $(zmk_src_dir)/app/build/right/zephyr/zmk.uf2 $(mount_path)

