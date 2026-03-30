<!---*******************************************
*******Sistema Financiero Integral**************
*******Gestión de Activos Fijos*****************
*******Conciliacion de Activos Fijos************
*******Fecha de Creación: Ene/2006**************
*******Desarrollado por: Dorian Abarca Gómez****
********************************************--->

<cf_dbfunction name="to_number" args="VSvalor" 		returnvariable="VSvalor">
<cf_dbfunction name="to_char"   args="a.GATmes"  	returnvariable="GATmes">
<cf_dbfunction name="to_char"   args="a.GATperiodo" returnvariable="GATperiodo">
<cf_dbfunction name="to_char"   args="a.Cconcepto"  returnvariable="Cconcepto">
<cf_dbfunction name="to_char"   args="a.Edocumento" returnvariable="Edocumento">
<cf_dbfunction name="to_char"   args="coalesce(a.Cconcepto, -10)"   returnvariable="Cconcepto2">
<cf_dbfunction name="to_char"   args="coalesce(a.Edocumento, -10)"  returnvariable="Edocumento2">

<cf_dbfunction name="concat" args="#GATperiodo#;'|';#GATmes#;'|';#Cconcepto#;'|';#Edocumento#"  returnvariable="inactivecol" delimiters= ";">
<cf_dbfunction name="concat" args="'<a href=''##'' onclick=''javascript:MostrarReporte('+#GATperiodo#+','+#GATmes#+','+#Cconcepto2#+','+#Edocumento2#+')''><img src=''/cfmx/sif/imagenes/findsmall.gif'' width=''16'' height=''16'' border=''0'' /></a>'"  returnvariable="img" delimiters= "+">
<cf_dbfunction name="concat" args="'<a href=''##'' onclick=''javascript:MostrarAjustes('+#GATperiodo#+','+#GATmes#+','+#Cconcepto2#+','+#Edocumento2#+')''><img src=''/cfmx/sif/imagenes/iedit.gif'' width=''16'' height=''16'' border=''0'' alt=''Ver Activos a Ajustar'' /></a>'"  returnvariable="img1" delimiters= "+">
<cfinvoke component="sif.Componentes.pListas" method="pLista"
	columnas="distinct a.GATperiodo, a.GATmes, 
			 (coalesce(
			   (select min(VSdesc)
			     from VSidioma vs
				where Iid = (select min(Iid) from Idiomas id where id.Icodigo = '#SESSION.IDIOMA#')
				and VSgrupo = 1
				and #VSvalor# = a.GATmes)
				,#GATmes#)) as Mes, 
					
				b.Cconcepto, b.Cdescripcion, a.Edocumento,	
				case (select min(GATestado)
				        from GATransacciones b
				      where a.Ecodigo  = b.Ecodigo
				      and a.GATperiodo = b.GATperiodo
				      and a.GATmes     = b.GATmes
		              and a.Cconcepto  = b.Cconcepto
				      and a.Edocumento = b.Edocumento) 
				when 0 then 'Incompleto'
				when 1 then 'Completo'
				when 2 then 'Conciliado'
				end as Estado,
				case (select min(GATestado)
				       from GATransacciones b
					  where a.Ecodigo  = b.Ecodigo
					  and a.GATperiodo = b.GATperiodo
					  and a.GATmes     = b.GATmes
					  and a.Cconcepto  = b.Cconcepto
					  and a.Edocumento = b.Edocumento) 
				when 2 then ' ' else
					#inactivecol#
				end as inactivecol,
				#PreserveSingleQuotes(img)# as img,
						
				case when (	select count(1)
							from GATransacciones b
							where b.OcodigoAnt is not null
							  and b.Ocodigo != b.OcodigoAnt 
				  			  and a.Ecodigo = b.Ecodigo
							  and a.GATperiodo = b.GATperiodo
							  and a.GATmes = b.GATmes
							  and a.Cconcepto = b.Cconcepto
							  and a.Edocumento = b.Edocumento) = 0
				then
					' ' 
				else
					#PreserveSingleQuotes(img1)#					
				end as img1"
				
	tabla="GATransacciones a
				inner join ConceptoContableE b
				on b.Ecodigo = a.Ecodigo
				and b.Cconcepto = a.Cconcepto"
	filtro="a.Ecodigo = #SESSION.ECODIGO#
				and a.GATperiodo is not null
				and a.GATmes is not null
				and a.Cconcepto is not null
				and a.Edocumento is not null
				order by a.GATperiodo, a.GATmes, b.Cdescripcion, a.Edocumento"	
	desplegar="GATperiodo, Mes, Cdescripcion, Edocumento, Estado, Img, Img1"
	filtrar_por_array="#ListToArray(
			'a.GATperiodo|a.GATmes|a.Cconcepto|a.Edocumento|
			(select min(GATestado)
			from GATransacciones b
			where a.Ecodigo = b.Ecodigo
			and a.GATperiodo = b.GATperiodo
			and a.GATmes = b.GATmes
			and a.Cconcepto = b.Cconcepto
			and a.Edocumento = b.Edocumento)| | ','|')#"
	rsGATperiodo="#rsPeriodos#"
	rsMes="#rsMeses#"
	rsCdescripcion="#rsConceptos#"
	rsEstado="#rsEstados#"
	etiquetas="Periodo, Mes, Concepto, Documento, Estado, , "
	formatos="I, I, I, W, I, G, G"
	align="left, left, left, left, left, left, left"
	
	irA="Conciliacion.cfm"
	
	keys="GATperiodo, GATmes, Cconcepto, Edocumento"
	
	checkboxes="S"
	inactivecol="inactivecol"
	
	lineaazul	="Estado eq 'Completo'"
	linearoja	="Estado eq 'Incompleto'"
	
	botones="Aplicar,Continuar, Conciliar,Actualizar,Desactualizar"
		
	mostrar_filtro="true"
	filtrar_automatico="true"
	
	debug="N"
/>
<cfquery name="rsVerificaConciliacion" datasource="#session.dsn#">
 select count(1) as Cantidad
     from EAadquisicion
        where Ecodigo  = #session.Ecodigo#
          and EAstatus = -1                                                 
</cfquery>
<table cellpadding="0" cellspacing="0" align="left">
<tr>
	<td><img src="/cfmx/sif/imagenes/iedit.gif" width="16" height="16" border="0" alt="Requiere Ajuste Contable" /></td>
	<td>&nbsp;&nbsp;Se requiere realizar un ajuste contable</td>	
</tr>
<cfif rsVerificaConciliacion.Cantidad GT 0>
	<td><img src="/cfmx/sif/imagenes/stop.gif" width="16" height="16" border="0" alt="Proceso de Aplicación de conciliación incluso" /></td>
	<td>&nbsp;&nbsp;La Aplicación de conciliación quedo inconclusa, favor aplique el proceso de continuar!!</td>	
</cfif> 
</table>

<script language="javascript" type="text/javascript">
	<!--//
	function funcContinuar()
	{
	var continuar= confirm("¿Desea continuar Aplicando los Asientos que quedaron Pendientes?");
	return continuar;
	}

	//funcion para verificar si hay alguna transaccion marcada devuelve un booleano
	function algunoMarcado(){
		var aplica = false;
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				aplica = document.lista.chk.checked;
			} else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("¿Está seguro de que desea aplicar los documentos seleccionadas?"));
		} else {
			alert('Debe seleccionar al menos un documento antes de Aplicar');
			return false;
		}
	}
	
	function funcConciliar() {
		var PARAM  = "ConciliacionMasiva.cfm"
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=600,height=400')
		return false;
	}

	function funcActualizar() {
		var PARAM  = "CompletarMasiva.cfm"
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=700,height=300')
		return false;
	}
	function funcDesactualizar() {
		var PARAM  = "Desactualizar.cfm"
		window.open(PARAM,'','left=250,top=250,scrollbars=yes,resizable=yes,width=700,height=300')
		return false;
	}


	//funccion para Aplicar una o mas transacciones marcadas en la lista
	function funcAplicar() {
		//Retorna Verdadero y Cambia el Action para que se vaya para el sql de conciliar, por post, se lleva el chk donde irían 
		//las llaves requeridas para la conciliacion
		if (algunoMarcado())
			document.lista.action = "Conciliacion-sql.cfm";
		else
			return false;
		return true;
	}	
	
	function MostrarReporte(vGATperiodo, vGATmes, vCconcepto, vEdocumento) {
	
	}
	var _VControl  = false;
	var _VpopUpWin = null;
		
	function MostrarAjustes(vGATperiodo, vGATmes, vCconcepto, vEdocumento) {
		_VControl = false;
		_lvar_width = 800;
		_lvar_height = 600;
		_lvar_left = 100;
		_lvar_top = 100;
		_lvar_periodo = vGATperiodo;
		_lvar_mes = vGATmes;
		_lvar_concepto = vCconcepto;
		_lvar_edocumento = vEdocumento; 
		_lvar_estado = -1;
		if(_VpopUpWin) {
			if(!_VpopUpWin.closed) _VpopUpWin.close();
		}
		_VpopUpWin = open('/cfmx/sif/af/gestion/operacion/VerAjustes.cfm?periodo='+_lvar_periodo+'&mes='+_lvar_mes+'&concepto='+_lvar_concepto+'&edocumento='+_lvar_edocumento+'&estado='+_lvar_estado+'', '_VpopUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+_lvar_width+',height='+_lvar_height+',left='+_lvar_left+', top='+_lvar_top+',screenX='+_lvar_left+',screenY='+_lvar_top+'');
		return false;
	}	
	
	//-->
</script>