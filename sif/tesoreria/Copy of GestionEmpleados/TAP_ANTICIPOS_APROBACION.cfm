
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined('form.GELid') and form.GELid neq ''>
<cfset filtro="d.Ecodigo = #SESSION.ECODIGO# and a.GELid=#form.GELid#">
<cfelse>
<cfset filtro="d.Ecodigo = #SESSION.ECODIGO# and a.GELid=#GELid#">
</cfif>

<cf_dbfunction name="to_char" args="d.GEAnumero" returnvariable = "GEAnumero">
<cf_dbfunction name="to_char" args="a.GELid" returnvariable = "GELid">
<cf_dbfunction name="to_char" args="a.GEAid" returnvariable = "GEAid">
<cf_dbfunction name="to_char" args="coalesce(d.GEAviatico,'0')" returnvariable = "GEAviatico">
<cf_dbfunction name="concat" args="'<a href=''javascript:MostrarAjustes(' + #PreserveSingleQuotes(GEAnumero)# + ',' +  #PreserveSingleQuotes(GELid)#+',' +  #PreserveSingleQuotes(GEAid)#+',' +  #PreserveSingleQuotes(GEAviatico)#+')'+ ';''><img 	src=''/cfmx/sif/imagenes/findsmall.gif'' border=''0''></a>'"   returnvariable="img"  delimiters = "+">


<cfquery name="rsLista" datasource="#session.dsn#">
	select  
		d.GEAnumero,
		c.GEADmonto,
		c.GEADmonto - (c.GEADutilizado) as Saldo, 
		a.GEAid, 
		a.GELAtotal, 
		a.GELid, 
		a.GEADid, 
		b.GECdescripcion, 
		d.GEAdescripcion, 
		d.GEAfechaSolicitud, 
		m.Miso4217,
		#PreserveSingleQuotes(img)# as img,
		coalesce(d.GEAviatico,'0')  as viaticos ,
				case 
                        when 
                             d.GEAviatico = '1'  
                        then 
                        	'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
                        else
                            '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
                        end as viaticoIco   
		
		 from GEliquidacionAnts a 
		 inner join GEanticipoDet c 
		   on c.GEAid=a.GEAid and c.GEADid=a.GEADid 
		  inner join GEconceptoGasto b 
			on b.GECid=c.GECid 
		  inner join GEanticipo d 
			 on d.GEAid=a.GEAid
		 inner join Monedas m 
			on d.Mcodigo= m.Mcodigo 
		 where #filtro#
			and coalesce(d.GEAviatico,'0') = '0' 
		  
union
	select distinct 
		d.GEAnumero,
		d.GEAtotalOri as GEADmonto,
		d.GEAtotalOri as Saldo, 
		a.GEAid, 
		d.GEAtotalOri as GELAtotal, 
		a.GELid, 
		<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as GEADid, 
		d.GEAdescripcion as GECdescripcion, 
		d.GEAdescripcion, 
		d.GEAfechaSolicitud, 
		m.Miso4217,
		#PreserveSingleQuotes(img)# as img,
		d.GEAviatico as viaticos,
				case 
                        when 
                             d.GEAviatico = '1'  
                        then 
                        	'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
                        else
                            '<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
                        end as viaticoIco   
		
		from 
				GEliquidacionAnts a,GEanticipo d, Monedas m
			where	 
				a.GELid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GELid#">
				and d.GEAid=a.GEAid
				and d.Mcodigo= m.Mcodigo
				and coalesce(d.GEAviatico,'0') = '1' 

</cfquery>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsLista#"
				desplegar="GEAnumero,GEAfechaSolicitud,GECdescripcion,GEAdescripcion,Miso4217,GELAtotal,saldo,GEADmonto,viaticoIco,img"
				etiquetas="Anticipo,Fecha,Concepto,Descripcion,Moneda,Monto Anticipo,Saldo,Monto a Liquidar,Viatico, "
				formatos="S,D,S,S,S,M,M,M,S, G"
				align="left, left, left, left, left, left, left, left, left, right"
				irA="AprobarTrans.cfm?Tipo=GASTO&CCHTrelacionada=#form.GELid#"
				showEmptyListMsg="yes"
				keys="GEAid,GEADid"
				debug="N"
				maxRows="5"
				PageIndex="1"
				/>
				
<script language="javascript" type="text/javascript">
var _VControl  = false;
	var _VpopUpWin = null;
		
	function MostrarAjustes(GEAnumero,GELid,GEAid,GEAviatico) {
		_VControl = false;
		_lvar_width = 1200;
		_lvar_height = 600;
		_lvar_left = 100;
		_lvar_top = 100;
		_lvar_num = GEAnumero;
		_lvar_liq = GELid;
		_lvar_ant = GEAid;
		_lvar_via = GEAviatico;
		
		if(_VpopUpWin) {
			if(!_VpopUpWin.closed) _VpopUpWin.close();
		}
		_VpopUpWin = open('/cfmx/sif/tesoreria/GestionEmpleados/DetalleAnticipo.cfm?GEAnumero='+_lvar_num+'&GELid='+_lvar_liq+'&GEAviatico='+_lvar_via+'&GEAid='+_lvar_ant+'', '_VpopUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+_lvar_width+',height='+_lvar_height+',left='+_lvar_left+', top='+_lvar_top+',screenX='+_lvar_left+',screenY='+_lvar_top+'');
	}	
</script>
