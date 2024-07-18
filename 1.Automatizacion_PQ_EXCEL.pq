let
    Origen = Csv.Document(File.Contents("D:\DOCUMENTOS\CURSOS_DATA_ANALYTICS\CURSO_INTEGRADO_DATA_ANALIST\Big_CSV\Material de las Clases\1. Excel\1. Escenario_1\Sales_sin_transformar.csv"),[Delimiter=",", Columns=24, Encoding=1252, QuoteStyle=QuoteStyle.None]),
    #"Encabezados promovidos" = Table.PromoteHeaders(Origen, [PromoteAllScalars=true]),
    #"Otras columnas quitadas" = Table.SelectColumns(#"Encabezados promovidos",{"date", "city", "sale_dollars"}),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Otras columnas quitadas",{{"date", type date}}),
    #"Año insertado" = Table.AddColumn(#"Tipo cambiado", "Año", each Date.Year([date]), Int64.Type),
    #"Mes insertado" = Table.AddColumn(#"Año insertado", "Mes", each Date.Month([date]), Int64.Type),
    #"Columnas reordenadas" = Table.ReorderColumns(#"Mes insertado",{"date", "Mes", "Año", "city", "sale_dollars"}),
    #"Columnas quitadas" = Table.RemoveColumns(#"Columnas reordenadas",{"date"}),
    #"Columnas combinadas" = Table.CombineColumns(Table.TransformColumnTypes(#"Columnas quitadas", {{"Mes", type text}, {"Año", type text}}, "es-PE"),{"Mes", "Año"},Combiner.CombineTextByDelimiter("-", QuoteStyle.None),"Date"),
    #"Tipo cambiado1" = Table.TransformColumnTypes(#"Columnas combinadas",{{"Date", type date}, {"sale_dollars", Currency.Type}}),
    #"Filas agrupadas" = Table.Group(#"Tipo cambiado1", {"Date", "city"}, {{"Sales", each List.Sum([sale_dollars]), type nullable number}})
in
    #"Filas agrupadas"