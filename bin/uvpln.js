#!/usr/bin/env node
// uvpln — CLI principal
//
// Sin args        → lanza Claude Code con CLAUDE_CONFIG_DIR=~/.claude-uvpln
// install         → copia claude/ a ~/.claude-uvpln/
// uninstall       → remueve ~/.claude-uvpln/
// status          → estado de la instalación
// --help / -h     → ayuda generada por commander
// --version / -v  → versión del paquete
// otros args      → passthrough a claude (ej: uvpln chat hello)

const pkg = require('../package.json')
const { runDefault } = require('../src/run')

const KNOWN_SUBS = ['install', 'uninstall', 'status']
const HELP_FLAGS = ['--help', '-h', '--version', '-v', 'help']

const argv = process.argv.slice(2)
const first = argv[0]

if (!first) {
  // Sin args → lanzar claude directamente
  runDefault([])
} else if (KNOWN_SUBS.includes(first) || HELP_FLAGS.includes(first)) {
  // Subcomando conocido o flag de help/version → commander
  const { Command } = require('commander')
  const program = new Command()

  program
    .name('uvpln')
    .description('Ecosistema de agentes frontend para Claude Code (instalación aislada)')
    .version(pkg.version, '-v, --version', 'Muestra la versión')
    .helpOption('-h, --help', 'Muestra esta ayuda')
    .addHelpText('after', `
Uso normal:
  $ uvpln                  Lanza Claude Code con uvpln (no toca claude vanilla)
  $ uvpln chat hola        Passthrough — equivalente a "claude chat hola" con uvpln

Comandos:
  $ uvpln install          Instalar uvpln en ~/.claude-uvpln/
  $ uvpln uninstall        Desinstalar uvpln (Claude vanilla queda intacto)
  $ uvpln status           Ver qué está instalado

Más info: https://github.com/jcarlosabc/un-viernes-por-la-noche
`)

  program
    .command('install')
    .description('Instalar uvpln en ~/.claude-uvpln/ (modo aislado)')
    .option('-f, --force', 'Sobrescribir sin preguntar')
    .action((opts) => require('../src/install').installCmd(opts))

  program
    .command('uninstall')
    .description('Desinstalar uvpln — borra todo, Claude vanilla queda intacto')
    .option('-y, --yes', 'No pedir confirmación')
    .action((opts) => require('../src/uninstall').uninstallCmd(opts))

  program
    .command('status')
    .description('Mostrar el estado de la instalación')
    .action(() => require('../src/status').statusCmd())

  program.parse(process.argv)
} else {
  // Cualquier otra cosa → passthrough a claude
  runDefault(argv)
}
