import { modules, quiz, stats } from './content.js';

const icons = { grad:'🎓', spark:'✨', book:'📚', brain:'🧠', trophy:'🏆', shield:'🛡️', check:'✅', search:'🔎', play:'▶️' };
let quizIndex = 0;
let selectedAnswer = null;

function moduleCard(module) {
  return `<article class="course"><div class="pill-row"><span>${module.level}</span><span>${module.tag}</span></div><h3>${module.title}</h3><p>${module.summary}</p><div class="meta"><span>${module.lessons} lessons</span><span>${module.minutes} min</span></div><div class="progress"><span style="width:${module.progress}%"></span></div><button type="button">Continue ›</button></article>`;
}

function renderCourses(query = '') {
  const target = document.querySelector('#course-grid');
  const filtered = modules.filter((module) => `${module.title} ${module.level} ${module.tag}`.toLowerCase().includes(query.toLowerCase()));
  target.innerHTML = filtered.length ? filtered.map(moduleCard).join('') : '<p class="empty">No courses match that search yet.</p>';
}

function renderQuiz() {
  const item = quiz[quizIndex];
  const result = selectedAnswer === null ? '' : `<p class="feedback ${selectedAnswer === item.answer ? 'good' : 'bad'}">${selectedAnswer === item.answer ? 'Correct — safe distance and calm observation come first.' : 'Not quite. Prioritize distance, observation, and expert help.'}</p>`;
  document.querySelector('#quiz-panel').innerHTML = `<p class="eyebrow">${icons.brain} Knowledge check</p><h2>${item.q}</h2><div class="choices">${item.choices.map((choice, index) => `<button type="button" class="${selectedAnswer === index ? 'selected' : ''}" data-answer="${index}">${choice}</button>`).join('')}</div>${result}<button class="button primary" id="next-question" type="button">Next question</button>`;
  document.querySelectorAll('[data-answer]').forEach((button) => button.addEventListener('click', () => { selectedAnswer = Number(button.dataset.answer); renderQuiz(); }));
  document.querySelector('#next-question').addEventListener('click', () => { selectedAnswer = null; quizIndex = (quizIndex + 1) % quiz.length; renderQuiz(); });
}

function renderApp() {
  document.querySelector('#root').innerHTML = `<main><section class="hero"><nav class="nav"><div class="brand"><span>${icons.grad}</span>Snake Academy</div><a href="#courses">Courses</a><a href="#quiz">Quiz</a><a href="#field-guide">Field Guide</a></nav><div class="hero-grid"><div class="hero-copy"><p class="eyebrow">${icons.spark} Science-backed reptile education</p><h1>Learn snake safety, identification, and field ethics with confidence.</h1><p class="lede">Snake Academy turns expert herpetology concepts into friendly lessons, scenario drills, and visual species practice for curious beginners and outdoor professionals.</p><div class="actions"><a class="button primary" href="#courses">${icons.play} Start learning</a><a class="button secondary" href="#quiz">Take quick quiz</a></div><div class="stats">${stats.map((stat) => `<div><strong>${stat.value}</strong><span>${stat.label}</span></div>`).join('')}</div></div><div class="hero-card"><div class="card-top"><span>${icons.shield}</span><span>Featured Path</span></div><h2>Backyard Encounter Ready</h2><p>Master the three-step SPACE framework: Stop, Position, Assess, Contact Experts.</p><div class="progress"><span style="width:84%"></span></div><small>84% average completion rate</small></div></div></section><section class="section" id="courses"><div class="section-heading"><div><p class="eyebrow">${icons.book} Course library</p><h2>Choose a learning path</h2></div><label class="search">${icons.search}<input id="course-search" placeholder="Search courses" /></label></div><div class="course-grid" id="course-grid"></div></section><section class="section split" id="quiz"><div class="panel" id="quiz-panel"></div><div class="panel field" id="field-guide"><p class="eyebrow">${icons.trophy} Field guide preview</p><h2>Observation checklist</h2><ul><li>${icons.check} Keep at least several body lengths away.</li><li>${icons.check} Photograph without handling or disturbing habitat.</li><li>${icons.check} Note location, weather, behavior, and markings.</li><li>${icons.check} Contact local wildlife experts for urgent situations.</li></ul></div></section></main>`;
  renderCourses(); renderQuiz();
  document.querySelector('#course-search').addEventListener('input', (event) => renderCourses(event.target.value));
}

renderApp();
