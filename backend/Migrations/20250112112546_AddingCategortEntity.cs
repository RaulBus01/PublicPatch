using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PublicPatch.Migrations
{
    /// <inheritdoc />
    public partial class AddingCategortEntity : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Reports_CategoryId",
                table: "Reports",
                column: "CategoryId");

            migrationBuilder.AddForeignKey(
                name: "FK_Reports_Categories_CategoryId",
                table: "Reports",
                column: "CategoryId",
                principalTable: "Categories",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Reports_Categories_CategoryId",
                table: "Reports");

            migrationBuilder.DropIndex(
                name: "IX_Reports_CategoryId",
                table: "Reports");
        }
    }
}
