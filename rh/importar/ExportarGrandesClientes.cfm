<cfinvoke component="rh.Componentes.RH_ReporteCCSS_GC"
  method="ReporteCCSS"
  returnvariable="err"
  Ecodigo= "#Session.Ecodigo#"
  periodo="#form.CPperiodo#"
  mes="#form.CPmes#"
  GrupoPlanillas="#trim(form.GrupoPlanilla)#"
  Usucodigo="#Session.Usucodigo#"
  conexion="#Session.DSN#"
  validar="false"
  debug="false">
</cfinvoke>