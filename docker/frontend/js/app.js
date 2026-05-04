function showAuthPage() {
  document.getElementById('page-auth').classList.add('active');
  document.getElementById('page-main').classList.remove('active');
}

function showMainPage() {
  const user = JSON.parse(localStorage.getItem('user') || '{}');
  document.getElementById('user-email').textContent = user.email || '';
  document.getElementById('page-auth').classList.remove('active');
  document.getElementById('page-main').classList.add('active');
  loadMedia();
}

function initTheme() {
  const saved = localStorage.getItem('theme') || 'dark';
  applyTheme(saved);
}

function applyTheme(theme) {
  const btn = document.getElementById('btn-theme');
  if (theme === 'light') {
    document.documentElement.setAttribute('data-theme', 'light');
    if (btn) btn.textContent = '☀️';
  } else {
    document.documentElement.removeAttribute('data-theme');
    if (btn) btn.textContent = '🌙';
  }
  localStorage.setItem('theme', theme);
}

document.addEventListener('DOMContentLoaded', () => {
  initAuth();
  initCatalog();
  initTheme();

  document.getElementById('btn-theme').addEventListener('click', () => {
    const current = localStorage.getItem('theme') || 'dark';
    applyTheme(current === 'dark' ? 'light' : 'dark');
  });

  document.getElementById('btn-logout').addEventListener('click', () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    showAuthPage();
  });

  const token = localStorage.getItem('token');
  if (token) showMainPage();
  else showAuthPage();
});