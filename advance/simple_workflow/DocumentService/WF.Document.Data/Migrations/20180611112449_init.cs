using System;

using Microsoft.EntityFrameworkCore.Migrations;

namespace WF.Document.Data.Migrations
{
    public partial class init : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "OTItemHistories",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Comment = table.Column<string>(nullable: true),
                    Created = table.Column<DateTime>(nullable: false),
                    NumberOfRequestDays = table.Column<string>(nullable: true),
                    RequestForUser = table.Column<string>(nullable: true),
                    Requester = table.Column<string>(nullable: true),
                    StartDate = table.Column<string>(nullable: true),
                    WorkflowId = table.Column<Guid>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_OTItemHistories", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Users",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    UserName = table.Column<string>(nullable: true),
                    UserRoles = table.Column<string>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Users", x => x.Id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "OTItemHistories");

            migrationBuilder.DropTable(
                name: "Users");
        }
    }
}
