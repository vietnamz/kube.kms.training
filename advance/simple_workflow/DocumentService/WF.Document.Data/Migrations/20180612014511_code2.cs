using Microsoft.EntityFrameworkCore.Migrations;

namespace WF.Document.Data.Migrations
{
    public partial class code2 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "CurrenctState",
                table: "OTItemHistories",
                newName: "Executor");

            migrationBuilder.AddColumn<string>(
                name: "CurrentState",
                table: "OTItemHistories",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "CurrentState",
                table: "OTItemHistories");

            migrationBuilder.RenameColumn(
                name: "Executor",
                table: "OTItemHistories",
                newName: "CurrenctState");
        }
    }
}
