<cfinclude template="Transacciones-common.cfm">
<cf_dbfunction name="to_number" args="VSvalor" 		returnvariable="VSvalor">
<cf_dbfunction name="to_char"   args="a.GATmes"  	returnvariable="GATmes">
<cf_dbfunction name="to_char"   args="a.GATperiodo" returnvariable="GATperiodo">
<cf_dbfunction name="to_char"   args="a.Cconcepto"  returnvariable="Cconcepto">
<cf_dbfunction name="to_char"   args="a.Edocumento" returnvariable="Edocumento">
<cf_dbfunction name="to_char"   args="coalesce(a.Cconcepto, -10)"   returnvariable="Cconcepto2">
<cf_dbfunction name="to_char"   args="coalesce(a.Edocumento, -10)"  returnvariable="Edocumento2">
<cf_dbfunction name="concat" args="'<a href=''##'' onclick=''javascript:MostrarReporte('+#GATperiodo#+','+#GATmes#+','+#Cconcepto2#+','+#Edocumento2#+')''><img src=''/cfmx/sif/imagenes/findsmall.gif'' width=''16'' height=''16'' border=''0'' /></a>'"  returnvariable="img" delimiters= "+">

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
				      where a.Ecodigo = b.Ecodigo
					  and a.GATperiodo = b.GATperiodo
					  and a.GATmes = b.GATmes
					  and a.Cconcepto = b.Cconcepto
					  and a.Edocumento = b.Edocumento) 
				when 0 then 'Incompleto'
				when 1 then 'Completo'
				when 2 then 'Conciliado'
				end as Estado,
				#PreserveSingleQuotes(img)# as img"
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
	desplegar="GATperiodo, Mes, Cdescripcion, Edocumento, Estado, Img"
	filtrar_por_array="#ListToArray(
			'a.GATperiodo|a.GATmes|a.Cconcepto|a.Edocumento|
			(select min(GATestado)
			from GATransacciones b
			where a.Ecodigo = b.Ecodigo
			and a.GATperiodo = b.GATperiodo
			and a.GATmes = b.GATmes
			and a.Cconcepto = b.Cconcepto
			and a.Edocumento = b.Edocumento)| ','|')#"
	rsGATperiodo="#rsPeriodos#"
	rsMes="#rsMeses#"
	rsCdescripcion="#rsConceptos#"
	rsEstado="#rsEstados#"
	etiquetas="Periodo, Mes, Concepto, Documento, Estado, "
	formatos="I, I, I, W, I, G"
	align="left, left, left, left, left, left"
	
	irA="Transacciones.cfm"
	
	funcion="AsignarValidando"
	fparams="GATperiodo, GATmes, Cconcepto, Edocumento"
	
	mostrar_filtro="true"
	filtrar_automatico="true"
	
	MaxRows="25"
	
	pageIndex="2"

	debug="N"
/>
<script language="javascript" type="text/javascript">
	<!--//
	
	//funcion del onclik de las lineas de la lista *** asigna valores a las variables requeridas antes de hacer el submit
	//pero antes valida que todas tengan valores, de no ser así no hace nada y muestra un mensaje inidicando que no puede modificar
	//estos datos, pero que puede hacer click en la lupa de la derecha para ver la consulta... 
	var _VControl  = false;
	var _VpopUpWin = null;
	function AsignarValidando(vGATperiodo, vGATmes, vCconcepto, vEdocumento) {
		if (vGATperiodo.length>0&&vGATperiodo!=''&&vGATperiodo!='NA'&& 
			vGATmes.length>0&&vGATmes!=''&&vGATmes!='NA'&&
			vCconcepto.length>0&&vCconcepto!=''&&vCconcepto!='NA'&&
			vEdocumento.length>0&&vEdocumento!=''&&vEdocumento!='NA'&&
			!_VControl ) {
			document.lista.GATPERIODO.value = vGATperiodo;
			document.lista.GATMES.value = vGATmes;
			document.lista.CCONCEPTO.value = vCconcepto;
			document.lista.EDOCUMENTO.value = vEdocumento;
			document.lista.submit();
		} else if (!_VControl) {
			alert("Los Registros del documento actual no pueden ser modificados,\n porque el documento no tiene asignado un asiento contable.");
		} else {
			_VControl = false;
		}
	}
	function MostrarReporte(vGATperiodo, vGATmes, vCconcepto, vEdocumento) {
		_VControl = true;
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
		_VpopUpWin = open('/cfmx/sif/af/gestion/consultas/gabTransaccionesSinAplicarRep.cfm?periodo='+_lvar_periodo+'&mes='+_lvar_mes+'&concepto='+_lvar_concepto+'&edocumento='+_lvar_edocumento+'&estado='+_lvar_estado+'', '_VpopUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+_lvar_width+',height='+_lvar_height+',left='+_lvar_left+', top='+_lvar_top+',screenX='+_lvar_left+',screenY='+_lvar_top+'');
	}
	
	//-->
</script>