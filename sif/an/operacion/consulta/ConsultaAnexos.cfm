<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<link href="/cfmx/sif/js/xtree/xtree.css" rel="stylesheet" type="text/css">
<script language="JavaScript" src="/cfmx/sif/js/xtree/xtree.js"></script>

<cfquery datasource="#session.dsn#" name="rsMonedas">
Select -1 as Value, 'Todas' as Description from dual
union
Select A.Mcodigo as Value ,Mnombre as Description 
from AnexoCalculo A, Monedas  B
where A.Mcodigo = B.Mcodigo
  and ACstatus = 'T'
  and ((A.Ecodigo = #session.Ecodigo#) 
			    or (A.Ecodigo = -1 and A.GEid != -1 				
				and exists (select Ecodigo 
		    				from AnexoGEmpresaDet ged where ged.GEid = A.GEid
						     and ged.Ecodigo = #session.Ecodigo#)))

order by Value
</cfquery>

<cfquery datasource="#session.dsn#" name="rsCboMes">
Select '' as Value, 'Todos' as Description from dual
union
Select distinct <cf_dbfunction name="to_char" args="ACmes"> as Value, 
				<cf_dbfunction name="to_char" args="ACmes"> as Description
from AnexoCalculo e
where e.ACstatus = 'T'
  and ((e.Ecodigo = #session.Ecodigo#) 
			    or (e.Ecodigo = -1 and e.GEid != -1 				
				and exists (select Ecodigo 
		    				from AnexoGEmpresaDet ged where ged.GEid = e.GEid
						     and ged.Ecodigo = #session.Ecodigo#)))
order by Value
</cfquery>

<cfquery datasource="#session.dsn#" name="rsCboAno">
Select '' as Value, 'Todos' as Description from dual
union
Select distinct <cf_dbfunction name="to_char" args="ACano"> as Value, <cf_dbfunction name="to_char" args="ACano"> as Description
from AnexoCalculo e
where ACstatus = 'T'
  and ((e.Ecodigo = #session.Ecodigo#) 
			    or (e.Ecodigo = -1 and e.GEid != -1 				
				and exists (select Ecodigo 
		    				from AnexoGEmpresaDet ged where ged.GEid = e.GEid
						     and ged.Ecodigo = #session.Ecodigo#)))
order by Value
</cfquery>

<cfquery datasource="#session.dsn#" name="rsCboUnidades">
Select -1 as Value, 'Todas' as Description from dual
union
Select distinct ACunidad as Value,  <cf_dbfunction name="to_char" args="ACunidad"> as Description
from AnexoCalculo e
where ACstatus = 'T'
  and ((e.Ecodigo = #session.Ecodigo#) 
			    or (e.Ecodigo = -1 and e.GEid != -1 				
				and exists (select Ecodigo 
		    				from AnexoGEmpresaDet ged where ged.GEid = e.GEid
						     and ged.Ecodigo = #session.Ecodigo#)))

order by Value
</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaRH" 
		tabla="AnexoCalculo e				
				inner join Anexo anx
					on anx.AnexoId = e.AnexoId				
				left join Empresas emp
					on emp.Ecodigo = e.Ecodigo		
				left join Monedas m
					on m.Mcodigo = e.Mcodigo
				left join Oficinas o
					on  o.Ocodigo = e.Ocodigo
					and o.Ecodigo = e.Ecodigo
				left join AnexoGEmpresa ge
					on ge.GEid = e.GEid
				left join AnexoGOficina go
					on go.GOid = e.GOid" 
		columnas="anx.AnexoDes ,e.ACid, e.AnexoId, e.ACano, e.ACmes, e.Mcodigo,	e.ACunidad,
				  case when e.Mcodigo = -1 then 'Todas las Monedas' else m.Mnombre end as Moneda,
				  case when e.Mcodigo = -1 OR e.ACmLocal = 1 then 'En Local' else m.Mnombre end as Expresion,
			  	  case when e.Ecodigo != -1 then 'Empresa: ' #_Cat# emp.Edescripcion
					   when e.Ocodigo != -1 then 'Oficina: ' #_Cat# o.Odescripcion
					   when e.GEid    != -1 then 'Grupo Empresas: ' #_Cat# ge.GEnombre
					   when e.GOid    != -1 then 'Grupo Oficinas: ' #_Cat# go.GOnombre	end as Calculadopara" 
		desplegar="AnexoDes, ACano, ACmes, Moneda, Expresion, ACunidad, Calculadopara"
		etiquetas="Anexo, A&ntilde;o, Mes, Moneda, Expresado, Unidad, Calculado para" 
		formatos="S,S,S,S,U,S,S"
		filtro=" e.ACstatus = 'T' and ((e.Ecodigo = #session.Ecodigo#) 
			    or (e.Ecodigo = -1 and e.GEid != -1 				
				and exists (select Ecodigo 
		    				from AnexoGEmpresaDet ged where ged.GEid = e.GEid
						     and ged.Ecodigo = #session.Ecodigo#)))
							order by e.ACano desc, e.ACmes desc, e.Mcodigo asc, 
							e.GEid asc, e.GOid asc,	e.Ocodigo asc, e.ACunidad asc"
		align="left, left, left, left, left, left, left"
		checkboxes="N"
		keys="ACid,AnexoId"
		ira="newindex.cfm"
		mostrar_filtro="true"
		filtrar_automatico="true"
		filtrar_por="anx.AnexoDes, e.ACano, e.ACmes, e.Mcodigo, 0, e.ACunidad,
		case when e.Ecodigo    != -1 then 'Empresa: ' #_Cat# emp.Edescripcion
					   when e.Ocodigo != -1 then 'Oficina: ' #_Cat# o.Odescripcion
					   when e.GEid    != -1 then 'Grupo Empresas: ' #_Cat# ge.GEnombre
					   when e.GOid    != -1 then 'Grupo Oficinas: ' #_Cat# go.GOnombre	end"
		showemptylistmsg="true"
		rsMoneda = "#rsMonedas#"
		rsACmes = "#rsCboMes#"
		rsACano = "#rsCboAno#"
		rsACunidad = "#rsCboUnidades#">
</cfinvoke>