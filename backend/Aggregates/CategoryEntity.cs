using Microsoft.EntityFrameworkCore;

namespace PublicPatch.Aggregates
{
    public class CategoryEntity
    {
        public CategoryEntity()
        {
        }
        public CategoryEntity(string name, string description)
        {
            Name = name;
            Description = description;
        }

        public int Id { get; set; }
        public string Name { get; set; }
        public string Description { get; set; }
    }
}