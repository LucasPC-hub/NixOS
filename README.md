# 🖥️ Configuração NixOS

Uma configuração pessoal e moderna do NixOS com suporte a NVIDIA/Intel híbrido, Niri compositor, e desenvolvimento.

## 📦 Principais Pacotes Instalados

### 🎮 Gaming & Entretenimento
- **ProtonPlus** - Gerenciador do Proton
- **Lutris** - Plataforma de jogos open-source
- **PrismLauncher** - Launcher do Minecraft
- **Heroic** - Launcher para Epic Games Store
- **MPV** - Player de mídia minimalista
- **OBS Studio** - Gravação e streaming
- **Steam** (via módulo sistema)

### 🛠️ Desenvolvimento
- **Zed Editor** - Editor moderno e rápido
- **WebStorm** (JetBrains) - IDE para desenvolvimento web
- **VS Code** - Editor com extensões configuradas
- **NixVim** - Configuração Neovim personalizada
- **Rustup** - Toolchain do Rust
- **GCC** - Compilador C/C++
- **Node.js & NPM** - Desenvolvimento JavaScript/TypeScript
- **GitHub CLI** - Ferramenta CLI do GitHub
- **Mockoon** - Mock de APIs
- **Insomnia** - Cliente REST
- **LazyDocker** - Interface TUI para Docker

### 🖥️ Desktop & Produtividade
- **Niri** - Compositor Wayland com scrollable tiling
- **Walker** - Application launcher
- **Nautilus** - Gerenciador de arquivos GNOME
- **Dolphin** - Gerenciador de arquivos KDE
- **Yazi** - Gerenciador de arquivos terminal
- **Obsidian** - Aplicativo de notas
- **Firefox** & **Zen Browser** - Navegadores web
- **Vesktop** - Cliente Discord com temas customizados

### 🎵 Áudio & Multimídia
- **MPD** - Music Player Daemon
- **RMPC** - Cliente MPD com interface rica
- **Cava** - Visualizador de áudio
- **PipeWire** (96kHz configurado) - Sistema de áudio
- **Spicetify** - Customização do Spotify

### 🔧 Utilitários
- **Btop** - Monitor de sistema
- **Fish Shell** - Shell amigável
- **Fastfetch** - Informações do sistema
- **Tree** - Visualização de diretórios
- **ImageMagick** - Manipulação de imagens
- **GPU Screen Recorder** - Gravação usando GPU
- **DroidCam** - Usar telefone como webcam

## 🎨 Customização Visual

- **Stylix** - Sistema de temas globais
- **Material You** - Cores dinâmicas baseadas no wallpaper
- **Quickshell** - Shell desktop customizado
- **Nerd Fonts** - Fontes com ícones
- **Layan Cursors** - Cursor theme

## 🎮 Configuração de GPU

### NVIDIA + Intel Híbrido (Configuração Atual)

A configuração atual usa **NVIDIA PRIME Offload** para otimizar bateria:

```nix
# hosts/default/configuration.nix (linhas 226-273)
hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = false;
  powerManagement.finegrained = false;
  open = false; # Usar driver proprietário (mais estável)
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;

  prime = {
    # IDs dos barramentos (encontrados com lspci)
    intelBusId = "PCI:0:2:0";    # Intel Meteor Lake-P Arc Graphics
    nvidiaBusId = "PCI:1:0:0";   # NVIDIA RTX 4070 Max-Q Mobile

    # Modo Offload - Intel como primário, NVIDIA sob demanda
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
  };
};
```

**Para executar aplicação com GPU NVIDIA:**
```bash
nvidia-offload <comando>
```

### 🔄 Alternativas de Configuração GPU

#### Para usar NVIDIA como GPU principal (Sync Mode):
```nix
# Descomente em configuration.nix linha 270:
# sync.enable = true;

# E comente as linhas de offload:
# offload = {
#   enable = true;
#   enableOffloadCmd = true;
# };
```

#### Para placas AMD:
```nix
# Substitua em configuration.nix linha 150:
videoDrivers = [ "amdgpu" ];

# E remova toda seção hardware.nvidia
```

#### Para Intel integrado apenas:
```nix
# Substitua em configuration.nix linha 150:
videoDrivers = [ "modesetting" ];

# E remova toda seção hardware.nvidia
```

## 🚀 Como Usar

### Primeiro Setup
```bash
# Clone a configuração
git clone <repo> ~/nixos-config
cd ~/nixos-config

# Aplique a configuração
sudo nixos-rebuild switch --flake .
```

### Aplicar Mudanças
```bash
# Rebuild rápido
nh os switch

# Ou manualmente
sudo nixos-rebuild switch --flake .
```

### Atualizar Sistema
```bash
# Atualizar flake.lock
nix flake update

# Aplicar atualizações
nh os switch
```

## 📁 Estrutura do Projeto

```
├── flake.nix                 # Configuração principal do flake
├── hosts/default/            # Configuração do host
│   ├── configuration.nix     # Configuração sistema principal
│   ├── home.nix             # Configuração home-manager
│   ├── packages.nix         # Pacotes do usuário
│   └── hardware-configuration.nix
├── system/                   # Módulos do sistema
│   ├── packages.nix         # Pacotes do sistema
│   ├── programs/            # Configurações de programas
│   └── environment.nix      # Variáveis de ambiente
└── home/                     # Configurações home-manager
    ├── niri/                # Configuração do compositor
    ├── programs/            # Configurações de aplicações
    └── editors/             # Configurações de editores
```

## ⚡ Características Especiais

- **Niri Compositor** - Tiling com scroll infinito
- **Quickshell** - Desktop shell customizado
- **Material You** - Cores dinâmicas
- **PRIME Offload** - Otimização de bateria
- **Fish Shell** - Shell moderno
- **Garbage Collection** - Limpeza automática diária
- **Rebuild Logging** - Log de rebuilds em JSON

## 🔧 Personalização

### Mudança de Tema
Os temas são gerenciados pelo Stylix. Para mudar:
1. Altere o wallpaper em `system/programs/stylix.nix`
2. Execute `nh os switch`

### Adicionar Pacotes
- Sistema: adicione em `system/packages.nix`
- Usuário: adicione em `hosts/default/packages.nix`

### Configurar Monitor
Display configurado para **2880x1800@120Hz** em `configuration.nix:80`

---

*Configuração otimizada para laptop com Intel + NVIDIA, Niri compositor e desenvolvimento moderno.*