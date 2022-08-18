Map<String, dynamic> variablesPopular() {
  return <String, dynamic>{
    "filters": {
      "childExpressions": {
        "filters": {"field": "Project.id", "op": "GE", "values": "1"},
        "operator": "AND"
      },
      "operator": "AND"
    },
    "orders": {
      "orders": {"field": "Project.views", "or": "DESC"}
    },
    "pagination": {"limit": 19}
  };
}

Map<String, dynamic> variablesLatest() {
  return <String, dynamic>{
    "filters": {
      "childExpressions": {
        "filters": {
          "field": "Project.id",
          "op": "GE",
          "values": ["1"]
        },
        "operator": "AND"
      },
      "operator": "AND"
    },
    "orders": {
      "orders": {"field": "Project.createAt", "or": "DESC"}
    },
    "pagination": {"limit": 16, "page": 1}
  };
}

Map<String, dynamic> variablesSearch(String query) {
  return <String, dynamic>{
    "filters": {
      "childExpressions": {
        "filters": {
          "field": "Project.name",
          "op": "LIKE",
          "values": query,
        },
        "operator": "AND"
      },
      "operator": "AND"
    },
    "orders": {
      "orders": {
        "field": "Project.views",
        "or": "DESC",
      }
    },
    "pagination": {
      "limit": 16,
    }
  };
}

Map<String, dynamic> variablesDbyId(int id) {
  return <String, dynamic>{
    "id": id,
    "order": {"number": "DESC"}
  };
}

Map<String, dynamic> variablespage(String id) {
  return <String, dynamic>{
    "id": id,
  };
}
