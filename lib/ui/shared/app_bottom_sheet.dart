import 'package:flutter/material.dart';

/// Exibe um bottom sheet padronizado com título, conteúdo e botões Salvar/Cancelar.
PersistentBottomSheetController showAppBottomSheet(
  BuildContext context, {
  required Widget content,
  bool enableDrag = true,
}) {
  return Scaffold.of(context).showBottomSheet(
    enableDrag: enableDrag,
    (context) => Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: content),
    ),
  );
}

/// Linha de botões padronizada para bottom sheets (Salvar + Cancelar).
class BottomSheetActions extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String saveLabel;
  final String cancelLabel;

  const BottomSheetActions({
    super.key,
    required this.isLoading,
    required this.onSave,
    required this.onCancel,
    this.saveLabel = 'Salvar',
    this.cancelLabel = 'Cancelar',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 40,
              child: TextButton(
                onPressed: isLoading ? null : onCancel,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text(cancelLabel),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 120,
              height: 40,
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(saveLabel),
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
