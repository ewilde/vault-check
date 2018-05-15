package main

import (
	"fmt"

	"pault.ag/go/ykpiv"
)

func main() {
	yubikey, err := ykpiv.New(ykpiv.Options{
		Verbose:            true,
		Reader:             "Yubico Yubikey NEO OTP+U2F+CCID 00 00",
		ManagementKeyIsPIN: true,
		PIN:                stringPtr("543454"),
	})
	if err != nil {
		panic(err)
	}
	defer yubikey.Close()

	version, err := yubikey.Version()
	if err != nil {
		panic(err)
	}

	fmt.Printf("Application version %s found.\n", version)

	err = yubikey.Login()
	if err != nil {
		panic(err)
	}

	fmt.Println("Login successful")

	certificate, err := yubikey.GetCertificate("9a")
}

func stringPtr(s string) *string {
	return &s
}
