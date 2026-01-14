export VERSION := `cat version`

all: dep patch

clean:
    rm -rf ./dynamic-localpv-provisioner

dep: clean
    git clone -b {{ VERSION }} --depth=1 https://github.com/openebs/dynamic-localpv-provisioner.git

[working-directory('dynamic-localpv-provisioner')]
patch:
    curl "https://github.com/openebs/dynamic-localpv-provisioner/compare/{{ VERSION }}...morlay:patch-{{ VERSION }}.patch" | git apply -v

ship:
    docker buildx build --push \
      --label=org.opencontainers.image.source=https://github.com/innoai-tech/dynamic-localpv-provisioner \
      --tag=ghcr.io/innoai-tech/dynamic-localpv-provisioner:{{ VERSION }} \
      --platform=linux/amd64,linux/arm64 \
      --file=./dynamic-localpv-provisioner/buildscripts/provisioner-localpv/provisioner-localpv.Dockerfile \
      ./dynamic-localpv-provisioner
