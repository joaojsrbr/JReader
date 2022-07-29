const String query = r''' query getProjects(
             $filters: FiltersExpression!,
             $orders: OrdersExpression!,
             $pagination: PaginationInput
        ) {
             getProjects(
                 orders: $orders,
                 filters: $filters,
                 pagination: $pagination
             ) {
                 projects {
                     id
                  		updateAt
                     name
                     cover
                  
                     type
            
                     updateAt
                     getChapters(order: { id: DESC }, skip: 0, take: 1) {
                         id
                    		images
                         title
                         number
                     }
                 }
                 count
                 currentPage
                limit
                totalPages
             }
         }''';

const String queryD = r'''query project($id: Int!,$order: ChaptersSorting!) {
             project(id: $id) {
                 id
                 name
                 type
                 description
                 authors
                 cover
                 getChapters(order: $order) {
                     id
                    number
                     title
                     createAt
                 }
                getTags(order: { id: DESC }) {
                    id
                    name
                }
            }
        }''';

const String querypage = r''' query getChapter($id: String!) {
             getChapters(
                 orders: {
                     orders: { or: ASC, field: "Chapter.id" }
                 }
                 filters: {
                    operator: AND,
                     filters: [
                         { op: EQ, field: "Chapter.id", values: [$id] }
                     ],
                     childExpressions: {
                         operator: AND,
                         filters: {
                             op: GE,
                             field: "Project.id",
                             relationField: "Chapter.project",
                             values: ["1"]
                         }
                     }
                 }
             ) {
                 chapters {
                     id
                     images
                     project { id }
                 }
             }
         }''';
