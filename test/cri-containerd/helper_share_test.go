//go:build windows && functional
// +build windows,functional

package cri_containerd

import (
	"context"

	"github.com/Microsoft/hcsshim/test/pkg/definitions/shimdiag"
)

func shareInUVM(ctx context.Context, client shimdiag.ShimDiagService, hostPath, uvmPath string, readOnly bool) error {
	req := &shimdiag.ShareRequest{
		HostPath: hostPath,
		UvmPath:  uvmPath,
		ReadOnly: readOnly,
	}
	_, err := client.DiagShare(ctx, req)
	if err != nil {
		return err
	}
	return nil
}
