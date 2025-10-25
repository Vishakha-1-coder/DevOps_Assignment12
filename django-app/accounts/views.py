from django.shortcuts import render, redirect
from .models import Login
from django.views.decorators.csrf import csrf_exempt

def login_view(request):
    msg = ''
    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        password = request.POST.get('password', '').strip()
        try:
            user = Login.objects.get(username=username, password=password)
            # store username in session
            request.session['username'] = user.username
            return redirect('home')
        except Login.DoesNotExist:
            msg = 'Invalid credentials'
    return render(request, 'accounts/login.html', {'msg': msg})

def register_view(request):
    msg = ''
    if request.method == 'POST':
        username = request.POST.get('username', '').strip()
        password = request.POST.get('password', '').strip()
        if username and password:
            if Login.objects.filter(username=username).exists():
                msg = 'Username already exists'
            else:
                Login.objects.create(username=username, password=password)
                msg = 'Registered successfully, please login'
                return redirect('login')
        else:
            msg = 'Missing username/password'
    return render(request, 'accounts/register.html', {'msg': msg})

def home_view(request):
    username = request.session.get('username')
    if not username:
        return redirect('login')
    return render(request, 'accounts/home.html', {'username': username})

def logout_view(request):
    request.session.flush()
    return redirect('login')
