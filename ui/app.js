/* Orkelya Scoreboard — NUI */
(function () {
  var board = document.getElementById('board');
  var rowsEl = document.getElementById('rows');
  var meta = { showPing: true, showId: true, labels: {} };

  function esc(s) {
    return String(s == null ? '' : s).replace(/[&<>"']/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
    });
  }
  function pingClass(p) { return p < 80 ? 'good' : (p < 150 ? 'mid' : 'bad'); }

  function renderRows(rows) {
    var html = '';
    (rows || []).forEach(function (r) {
      html += '<div class="row' + (r.me ? ' me' : '') + '">'
        + (meta.showId ? '<span class="r-id">' + esc(r.id) + '</span>' : '<span></span>')
        + '<span class="r-name">' + esc(r.name) + '</span>'
        + (meta.showPing ? '<span class="r-ping ' + pingClass(r.ping || 0) + '">' + esc(r.ping) + '</span>' : '<span></span>')
        + '</div>';
    });
    rowsEl.innerHTML = html;
  }

  window.addEventListener('message', function (ev) {
    var m = ev.data || {};
    if (m.type !== 'orkelya_score') return;
    if (m.action === 'open') {
      board.hidden = !m.on;
      document.body.className = 'pill-' + (m.pill || 'glass');
      return;
    }
    if (m.action === 'board') {
      meta.showPing = m.showPing !== false;
      meta.showId = m.showId !== false;
      meta.labels = m.labels || {};
      document.getElementById('server').textContent = m.server || 'FiveM';
  const br = m.brand || {};
  let lg = $('logo');
  if (br.logo) {
    if (!lg) { lg = document.createElement('img'); lg.id = 'logo';
      document.getElementById('server').parentNode.insertBefore(lg, document.getElementById('server')); }
    lg.src = br.logo; document.getElementById('server').classList.add('with-logo');
  } else if (lg) lg.remove();
  document.getElementById('board').style.setProperty('--ork-watermark',
    br.watermark ? 'url(' + br.watermark + ')' : 'none');
  const th = m.theme || {};
  Object.entries(th.vars || {}).forEach(([k, v]) =>
    document.documentElement.style.setProperty(k, v));
  let cs = document.getElementById('custom-theme');
  if (th.css) {
    if (!cs) { cs = document.createElement('style');
      cs.id = 'custom-theme'; document.head.appendChild(cs); }
    cs.textContent = th.css;
  }
      document.getElementById('max-v').textContent = m.max || 32;
      document.getElementById('count-v').textContent = m.count || 0;
      document.getElementById('c-id').textContent = (m.labels || {}).id || 'ID';
      document.getElementById('c-name').textContent = (m.labels || {}).name || 'NOMBRE';
      document.getElementById('c-ping').textContent = (m.labels || {}).ping || 'PING';
      document.getElementById('c-id').style.display = meta.showId ? '' : 'none';
      document.getElementById('c-ping').style.display = meta.showPing ? '' : 'none';
      document.getElementById('foot-t').textContent = m.footer || '';
      renderRows(m.rows);
      return;
    }
    if (m.action === 'refresh') {
      document.getElementById('count-v').textContent = m.count || 0;
      var sl = document.getElementById('staff-line');
      if (m.staff != null) { sl.hidden = false; document.getElementById('staff-v').textContent = m.staff; }
      renderRows(m.rows);
      return;
    }
  });

  /* Demo: file://.../index.html?demo=1[&pill=bare] */
  if (/[?&]demo=1/.test(location.search)) {
    var qs = new URLSearchParams(location.search);
    document.documentElement.className = 'demo';
    document.body.className = 'pill-' + (qs.get('pill') || 'glass');
    board.hidden = false;
    document.getElementById('server').textContent = 'Orkelya RP';
    document.getElementById('count-v').textContent = '47';
    document.getElementById('foot-t').textContent = 'discord.gg/orkelya';
    document.getElementById('staff-line').hidden = false;
    document.getElementById('staff-v').textContent = '3';
    var demo = [
      { id: 1, name: 'Ramón Delgado', ping: 34 }, { id: 4, name: 'Lucrecia Báez', ping: 52 },
      { id: 7, name: 'Vos Mismo', ping: 41, me: true }, { id: 12, name: 'El Tuerto', ping: 96 },
      { id: 19, name: 'Oficial Sosa', ping: 178 }, { id: 23, name: 'Capataz Ibarra', ping: 61 },
      { id: 31, name: 'Don Faustino', ping: 88 },
    ];
    renderRows(demo);
  }
})();
