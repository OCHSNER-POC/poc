var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Sample HTTP endpoints
app.MapGet("/", () => "Hello from .NET Core Web App!");

app.MapGet("/api/hello", () => new { message = "Hello World!", timestamp = DateTime.UtcNow });

app.MapPost("/api/echo", (object data) => new
{
    received = data,
    timestamp = DateTime.UtcNow,
    message = "Data received successfully!"
});

Console.WriteLine("Starting web application...");
app.Run();
