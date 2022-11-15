abstract class IAudioDeviceManager {
  Future<List<AudioDevice>> getInputs();
  Future<AudioDevice> getCurrentOutput();
  Stream<AudioDevice> get onCurrentChanged;
  void dispose();
}

class AudioDevice {
  final String name;
  final int? portIndex;
  final String? portName;
  AudioDevice({
    required this.name,
    this.portIndex,
    this.portName,
  });

  @override
  String toString() => 'AudioDevice(name: $name, portIndex: $portIndex, portName: $portName)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AudioDevice && other.name == name && other.portIndex == portIndex && other.portName == portName;
  }

  @override
  int get hashCode => name.hashCode ^ portIndex.hashCode ^ portName.hashCode;

  AudioDevice copyWith({
    String? name,
    int? portIndex,
    String? portName,
  }) {
    return AudioDevice(
      name: name ?? this.name,
      portIndex: portIndex ?? this.portIndex,
      portName: portName ?? this.portName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'portIndex': portIndex,
      'portName': portName,
    };
  }

  factory AudioDevice.fromMap(Map<String, dynamic> map) {
    return AudioDevice(
      name: map['name'] ?? '',
      portIndex: map['portIndex']?.toInt(),
      portName: map['portName'],
    );
  }
}
