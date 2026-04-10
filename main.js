document.addEventListener('DOMContentLoaded', () => {
    const actionButtons = document.querySelectorAll('.action-btn');

    actionButtons.forEach(btn => {
        btn.addEventListener('click', async (e) => {
            const productId = e.target.dataset.id;
            const action = e.target.dataset.action;

            try {
                const response = await fetch('/api/toggle_action', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({ product_id: productId, action: action })
                });

                if (response.status === 401) {
                    alert("Authentication required to access the Vault.");
                    window.location.href = '/login';
                    return;
                }

                const data = await response.json();
                if (data.status === 'Success') {
                    // Visual feedback for Neo-Brutalism
                    e.target.style.transform = 'scale(1.3)';
                    setTimeout(() => e.target.style.transform = 'scale(1)', 200);
                    
                    if(action === 'like') {
                        e.target.innerHTML = e.target.innerHTML === '🖤' ? '🧡' : '🖤';
                    }
                }
            } catch (error) {
                console.error("Transmission Error:", error);
            }
        });
    });
});
```
