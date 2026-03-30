  function ligaMensajeria(vCboAlumno,vCboPeriodo){
	var a=window.open('/cfmx/edu/responsable/comunicados.cfm', 'ComunicadosAlProfesor','left=50,top=10,scrollbars=yes,resiable=yes,width=500,height=350,alwaysRaised=yes','Comunicados al Profesor');
  }
  
  function fnReLoad()
  {
    if (document.getElementById("hdnTipoOperacion"))
      document.getElementById("hdnTipoOperacion").value = "";
    document.frmActividades.submit();
  }
  function fnConsultarActividades(LprmTipo, LprmFecha, LprmFechaFinal)
  {
    if (LprmTipo == "H")
	  return;
	document.frmActividades.hdnCodigo.value = "";
    document.frmActividades.hdnTipoOperacion.value = LprmTipo;
    document.frmActividades.hdnFecha.value = LprmFecha;
	if (LprmFechaFinal)
      document.frmActividades.hdnFechaFinal.value = LprmFechaFinal;
	else
      document.frmActividades.hdnFechaFinal.value = "";
	document.frmActividades.submit();
	return;
  }
  function fnConsultarCurso(LprmTipo, LprmCodigo)
  {
    link="consultarCursoEST.cfm?Tipo="+LprmTipo+"&Codigo="+LprmCodigo+"&Periodo="+document.frmActividades.cboPeriodo.value+"&E="+document.frmActividades.cboAlumno.value+"&G="+document.frmActividades.cboGrupo.value;
    LvarWin = window.open(link, "TemasxEvaluacion", "left=100,top=50,scrollbars=yes,resiable=yes,width=600,height=500,alwaysRaised=yes");
	LvarWin.focus();
	return;
  }
  function fnConsultarCursoDet(LprmTipoLista, LprmCodigo)
  {
    link="consultarCursoEST.cfm?Tipo=C&Codigo="+LprmCodigo+"&Periodo="+document.frmActividades.cboPeriodo.value+"&TipoLista="+LprmTipoLista+"&E="+document.frmActividades.cboAlumno.value+"&G="+document.frmActividades.cboGrupo.value+"&AllC=1";
    LvarWin = window.open(link, "TemasxEvaluacion", "left=100,top=50,scrollbars=yes,resiable=yes,width=600,height=500,alwaysRaised=yes");
	LvarWin.focus();
	return;
  }
  function fnConsultarMaterial(LprmCodigo)
  {
    link="/cfmx/edu/responsable/BusquedaMaterial.cfm?Tipo=C&Codigo="+LprmCodigo+"&Periodo="+document.frmActividades.cboPeriodo.value+"&E="+document.frmActividades.cboAlumno.value+"&AllC=1";
    LvarWin = window.open(link, "TemasxEvaluacion", "left=100,top=50,scrollbars=yes,resiable=yes,width=600,height=500,alwaysRaised=yes");
	LvarWin.focus();
	return;
  }
