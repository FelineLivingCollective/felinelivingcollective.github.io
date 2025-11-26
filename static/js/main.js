// Feline Living Collective - Main JS

document.addEventListener('DOMContentLoaded', () => {
    initThemeToggle();
    initScrollReveal();
});

/* ========================================
   Dark Mode Logic
   ======================================== */
function initThemeToggle() {
    const toggleBtn = document.getElementById('theme-toggle');
    const iconSun = toggleBtn.querySelector('.icon-sun');
    const iconMoon = toggleBtn.querySelector('.icon-moon');
    const body = document.body;

    // Check saved preference or system preference
    const savedTheme = localStorage.getItem('theme');
    const systemPrefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;

    if (savedTheme === 'dark' || (!savedTheme && systemPrefersDark)) {
        body.classList.add('dark-mode');
        updateIcons(true);
    }

    toggleBtn.addEventListener('click', () => {
        body.classList.toggle('dark-mode');
        const isDark = body.classList.contains('dark-mode');
        
        // Save preference
        localStorage.setItem('theme', isDark ? 'dark' : 'light');
        updateIcons(isDark);
    });

    function updateIcons(isDark) {
        if (isDark) {
            iconSun.style.display = 'none';
            iconMoon.style.display = 'block';
        } else {
            iconSun.style.display = 'block';
            iconMoon.style.display = 'none';
        }
    }
}

/* ========================================
   Scroll Reveal Animation
   ======================================== */
function initScrollReveal() {
    const reveals = document.querySelectorAll('.reveal');

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('active');
                // Optional: Stop observing once revealed
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1, // Trigger when 10% of element is visible
        rootMargin: "0px 0px -50px 0px" // Offset slightly
    });

    reveals.forEach(el => observer.observe(el));
}
