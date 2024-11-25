using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using PublicPatch.Models;
using PublicPatch.Services;

namespace PublicPatch.Controllers
{
    [ApiController]
    [Route("api/[controller]/reports")]
    public class ReportController : ControllerBase
    {
        private readonly ILogger<WeatherForecastController> _logger;
        private readonly IMapper mapper;
        private readonly IReportService reportService;

        public ReportController(ILogger<WeatherForecastController> logger,
            IMapper mapper,
            IReportService reportService)
        {
            _logger = logger;
            this.mapper = mapper;
            this.reportService = reportService;
        }

        [HttpPost("CreteReport")]
        public async Task<IActionResult>CreateReport([FromBody] CreateReportModel report)
        {
            await reportService.CreateReport(report);

            return Ok(report);
        }

        [HttpGet("GetReport{id}")]
        public async Task<IActionResult> GetReport(int id)
        {
            var report = await reportService.GetReportById(id);
            if (report == null)
            {
                return NotFound();
            }

            return Ok(report);
        }

        [HttpGet("GetUserReports{userId}")]
        public async Task<IActionResult> GetReportByUser(int userId)
        {
            var reports = await reportService.GetReportsByUser(userId);
            if (reports.Count() == 0)
            {
                return NotFound();
            }

            return Ok(reports);
        }

        [HttpPut("UpdateReport{reportId}")]
        public async Task<IActionResult> UpdateReport(int userId)
        {
            var reports = await reportService.GetReportsByUser(userId);
            if (reports.Count() == 0)
            {
                return NotFound();
            }

            return Ok(reports);
        }

        [HttpGet("GetReportsByZone{location}")]
        public async Task<IActionResult> GetReportsByZone(GetReportsLocation location )
        {
            var reports = reportService.GetReportsByZone(location);
            if (reports.Count() == 0)
            {
                return NotFound();
            }

            return Ok(reports);
        }
    }
}
