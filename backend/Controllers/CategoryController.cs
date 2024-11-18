using Microsoft.AspNetCore.Mvc;
using PublicPatch.Aggregates;
using PublicPatch.Models;
using PublicPatch.Services;

namespace PublicPatch.Controllers
{
    public class CategoryController : Controller
    {
        private readonly ILogger<CategoryController> logger;
        private readonly IReportService reportService;

        public CategoryController(ILogger<CategoryController> logger, IReportService reportService)
        {
            this.logger = logger;
            this.reportService = reportService;
        }

        [HttpGet("GetCategories")]
        public async Task<IActionResult> TestDbConnectionString()
        {
            return Ok(await reportService.GetCategories());
        }

        [HttpPost("CreateCategory")]
        public async Task<IActionResult> CreateCategory(CreateCategoryModel categoryModel)
        {
            var id = await reportService.CreateCategory(categoryModel);

            return Ok(id);
        }

    }
}
