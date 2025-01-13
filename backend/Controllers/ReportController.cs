using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using PublicPatch.Models;
using PublicPatch.Services;

namespace PublicPatch.Controllers
{
    [ApiController]
    [Route("reports")]
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

        [HttpPost("CreateReport")]
        public async Task<IActionResult> CreateReport([FromBody] CreateReportModel report)
        {
            await reportService.CreateReport(report);

            return Ok(report);
        }

        [HttpGet("GetReport/{id}")]
        public async Task<IActionResult> GetReport(int id)
        {
            var report = await reportService.GetReportById(id);
            if (report == null)
            {
                return NotFound();
            }

            return Ok(report);
        }

        [HttpGet("GetUserReports/{userId}")]
        public async Task<IActionResult> GetReportByUser(int userId)
        {
            var reports = await reportService.GetReportsByUser(userId);
            if (reports.Count() == 0)
            {
                return NotFound();
            }

            return Ok(reports);
        }

        [HttpGet("GetAllReports")]
        public async Task<IActionResult> GetAllReports()
        {
            var reports = await reportService.GetAllReports();
            if (reports.Count() == 0)
            {
                return NotFound();
            }
            return Ok(reports);
        }

        [HttpPut("UpdateReport/{reportId}")]
        public async Task<IActionResult> UpdateReport(UpdateReportModel updateReportModel)
        {
            try
            {
                var uptatedReport = await reportService.UpdateReport(updateReportModel);
                return Ok(uptatedReport);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpDelete("DeleteReport/{reportId}")]
        public async Task<IActionResult> DeleteReport(int reportId)
        {
            await reportService.DeleteReport(reportId);
            return Ok("Report deleted");
        }



            [HttpGet("GetReportsByZone")]
            public async Task<IActionResult> GetReportsByZone([FromQuery]GetReportsLocation location)
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
