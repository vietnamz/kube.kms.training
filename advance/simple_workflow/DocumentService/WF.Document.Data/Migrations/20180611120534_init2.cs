using Microsoft.EntityFrameworkCore.Migrations;

namespace WF.Document.Data.Migrations
{
    public partial class init2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "CurrenctState",
                table: "OTItemHistories",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CurrenctState",
                table: "OTItemHistories");
        }
    }
}
