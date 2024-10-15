class PaymentInfo {
  final String accountHolderName;
  final String accountNumber;
  final String bankName;
  final String branchName;
  final String ifsc;
  final String qrCode;

  PaymentInfo({
    required this.accountHolderName,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
    required this.ifsc,
    required this.qrCode,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      accountHolderName: json['AccountHolderName'],
      accountNumber: json['AccountNumber'],
      bankName: json['BankName'],
      branchName: json['BranchName'],
      ifsc: json['IFSC'],
      qrCode: json['QR_Code'],
    );
  }
}
