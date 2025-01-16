using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace PublicPatch.Migrations
{
    /// <inheritdoc />
    public partial class removeUniqueFCMKey : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_FCMTokenEntities_FCMKey",
                table: "FCMTokenEntities");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_FCMTokenEntities_FCMKey",
                table: "FCMTokenEntities",
                column: "FCMKey",
                unique: true);
        }
    }
}
