using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PublicPatch.Migrations
{
    /// <inheritdoc />
    public partial class ChangeDeviceType : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "deviceType",
                table: "FCMTokenEntities",
                newName: "DeviceType");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "DeviceType",
                table: "FCMTokenEntities",
                newName: "deviceType");
        }
    }
}
