// agents-config.js
// Única fuente de verdad para íconos y categorías de agentes uvpln.
// Cambiá acá y se refleja en statusline.cjs y session-start.js automáticamente.

const CATEGORIES = [
  {
    name: 'Diseño',
    icon: '🎨',
    agents: {
      'ui-architect':    '🏗️',
      'ui-designer':     '🎨',
      'tokens-manager':  '🪙',
      'design-bridge':   '🌉',
      'motion-designer': '🎬',
    },
  },
  {
    name: 'Ingeniería',
    icon: '💻',
    agents: {
      'api-integrator':         '🔌',
      'state-manager':          '🧠',
      'refactoring-specialist': '🔧',
      'ai-features-engineer':   '🤖',
      'form-specialist':        '📝',
    },
  },
  {
    name: 'Calidad',
    icon: '🛡️',
    agents: {
      'code-reviewer': '🔍',
      'ui-tester':     '🧪',
      'debugger':      '🐛',
      'a11y-expert':   '♿',
    },
  },
  {
    name: 'Optimización',
    icon: '🚀',
    agents: {
      'performance-ui':     '⚡',
      'seo-specialist':     '📈',
      'analytics-engineer': '📊',
      'ux-researcher':      '🔬',
    },
  },
  {
    name: 'Especializados',
    icon: '🧩',
    agents: {
      'security-frontend':   '🔒',
      'payments-specialist': '💳',
      'i18n-specialist':     '🌐',
      'email-designer':      '📧',
      'storybook-curator':   '📚',
    },
  },
]

// Map plano para acceso rápido por nombre de agente.
const AGENT_ICONS = CATEGORIES.reduce((acc, cat) => {
  Object.entries(cat.agents).forEach(([name, icon]) => { acc[name] = icon })
  return acc
}, {})

module.exports = { CATEGORIES, AGENT_ICONS }
