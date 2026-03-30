<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Anticipo" default ="Anticipo" returnvariable="LB_Anticipo" xmlfile = "TabT1_Anticipos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Fecha" default ="Fecha" returnvariable="LB_Fecha" xmlfile = "TabT1_Anticipos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default ="Descripcion" returnvariable="LB_Descripcion" xmlfile = "TabT1_Anticipos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoOriginal" default ="Monto Original" returnvariable="LB_MontoOriginal" xmlfile = "TabT1_Anticipos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Saldo" default ="Saldo" returnvariable="LB_Saldo" xmlfile = "TabT1_Anticipos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_MontoLiquidar" default ="Monto Liquidar" returnvariable="LB_MontoLiquidar" xmlfile = "TabT1_Anticipos.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Viatico" default ="Viatico" returnvariable="LB_Viatico" xmlfile = "TabT1_Anticipos.xml">
        
        
<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif isdefined('id') and #id# neq ''>
<cfset filtro="d.Ecodigo = #SESSION.ECODIGO# and a.GELid=#id#">
<cfelse>
<cfset filtro="d.Ecodigo = #SESSION.ECODIGO# and a.GELid=#GELid#">
</cfif>

<cf_dbfunction name="to_char" args="d.GEAnumero" returnvariable = "GEAnumero">
<cf_dbfunction name="to_char" args="a.GELid" returnvariable = "GELid">
<cf_dbfunction name="to_char" args="a.GEAid" returnvariable = "GEAid">
<cf_dbfunction name="to_char" args="b.GECid" returnvariable = "GECid">
<cf_dbfunction name="to_char" args="coalesce (d.GEAviatico,'0')" returnvariable = "GEAviatico">
<cf_dbfunction name="concat" args="'<a href=''javascript:MostrarAjustes(' + #PreserveSingleQuotes(GEAnumero)# + ','+  #PreserveSingleQuotes(GECid)#+',' +  #PreserveSingleQuotes(GELid)#+',' +  #PreserveSingleQuotes(GEAid)#+',' +  #PreserveSingleQuotes(GEAviatico)#+')'+ ';''><img 	src=''/cfmx/sif/imagenes/findsmall.gif'' border=''0''></a>'"   returnvariable="img"  delimiters = "+">


<cfquery name="rsLista" datasource="#session.dsn#">
select distinct 
		a.GELid,
		a.GEAid,
		a.GELAtotal, c.GEADmonto,
		c.CFcuenta,
		d.GEAtotalOri, 
		c.GEADutilizado,
		(c.GEADutilizado) as Saldo,
		c.TESDPaprobadopendiente,	
		d.GEAtotalOri as GELAtotalO,
		f.CFformato,
		d.GEAnumero,
		d.GEAdesde,
		d.GEAdescripcion,
		d.GEAhasta,
		d.GEAfechaPagar,
		d.GEAmanual,
		d.GEAfechaSolicitud,
		m.Miso4217,
		coalesce (d.GEAviatico,'0') as viatico, 
		case 
			when 
				 GEAviatico = '1'  
			then 
				'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
			else
				'<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
		end as viaticoIco, 
		( select rtrim(cf.CFcodigo) #LvarCNCT# '-' #LvarCNCT# cf.CFdescripcion
			from CFuncional cf 
			where cf.CFid = d.CFid
		) as CentroFuncional,
		(select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2
			from DatosEmpleado Em,TESbeneficiario te
			where d.TESBid=te.TESBid and   Em.DEid=te.DEid  
		) as Empleado,
		(select Mo.Mnombre
			from Monedas Mo
			where d.Mcodigo=Mo.Mcodigo
		)as Moneda,
		( select rtrim(ctf.CFformato) #LvarCNCT# ' ' #LvarCNCT# ctf.CFdescripcion
			from CFinanciera ctf	
			where ctf.CFcuenta = d.CFcuenta
		)as Cuenta,
		#PreserveSingleQuotes(img)# as img
	from GEliquidacionAnts a
		inner join GEanticipoDet c
			on c.GEAid=a.GEAid
			and c.GEADid=a.GEADid
		inner join CFinanciera f
			on f.CFcuenta = c.CFcuenta
		inner join GEconceptoGasto b
			on  b.GECid=c.GECid	
		inner join GEanticipo d
			on  d.GEAid=a.GEAid
		inner join Monedas m
			on d.Mcodigo= m.Mcodigo
	where #filtro#
	 and coalesce(d.GEAviatico,'0') = '0'
	UNION
	select distinct 
			a.GELid,
			a.GEAid,
			a.GELAtotal, c.GEADmonto,
			c.CFcuenta,
			d.GEAtotalOri,
			c.GEADutilizado,
			(c.GEADmonto-c.GEADutilizado) as Saldo,
			c.TESDPaprobadopendiente,	
			d.GEAtotalOri as GELAtotalO,
			f.CFformato,
			d.GEAnumero,
			d.GEAdesde,
			d.GEAdescripcion,
			d.GEAhasta,
			d.GEAfechaPagar,
			d.GEAmanual,
			d.GEAfechaSolicitud,
			m.Miso4217,
			coalesce (d.GEAviatico,'0') as viatico, 
			case 
				when 
					 GEAviatico = '1'  
				then 
					'<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
				else
					'<img src=''/cfmx/sif/imagenes/unchecked.gif'' border=''0''>'
			end as viaticoIco, 
			( select rtrim(cf.CFcodigo) #LvarCNCT# '-' #LvarCNCT# cf.CFdescripcion
				from CFuncional cf 
				where cf.CFid = d.CFid
			) as CentroFuncional,
			(select Em.DEnombre #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# Em.DEapellido2
				from DatosEmpleado Em,TESbeneficiario te
				where d.TESBid=te.TESBid and   Em.DEid=te.DEid  
			) as Empleado,
			(select Mo.Mnombre
				from Monedas Mo
				where d.Mcodigo=Mo.Mcodigo
			)as Moneda,
			( select rtrim(ctf.CFformato) #LvarCNCT# ' ' #LvarCNCT# ctf.CFdescripcion
				from CFinanciera ctf	
				where ctf.CFcuenta = d.CFcuenta
			)as Cuenta,
			#PreserveSingleQuotes(img)# as img
	from GEliquidacionAnts a
		inner join GEanticipoDet c
			on c.GEAid=a.GEAid
			and c.GEADid=a.GEADid
		inner join CFinanciera f
			on f.CFcuenta = c.CFcuenta
		inner join GEconceptoGasto b
			on  b.GECid=c.GECid	
		inner join GEanticipo d
			on  d.GEAid=a.GEAid
		inner join Monedas m
			on d.Mcodigo= m.Mcodigo
	where #filtro#
	 and coalesce(d.GEAviatico,'0') = '1'	 
</cfquery>


<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
	query="#rsLista#"
	irA="TransaccionCustodiaP.cfm"
	desplegar="GEAnumero,GEAfechaSolicitud,GEAdescripcion,GEADmonto,saldo,GELAtotal,viaticoIco,img"
	etiquetas="#LB_Anticipo#,#LB_Fecha#,#LB_Descripcion#,#LB_MontoOriginal#,#LB_Saldo#,#LB_MontoLiquidar#,#LB_Viatico#, "
	formatos="S,D,S,M,M,M,S,G"
	align="left, center, left, right,right,right,right, center"
	keys="GEAid"
	debug="N"
	maxRows="0"
PageIndex="21"
/>



<script language="javascript" type="text/javascript">
var _VControl  = false;
	var _VpopUpWin = null;
		
	function MostrarAjustes(GEAnumero,GECid,GELid,GEAid,GEAviatico) {
		_VControl = false;
		_lvar_width = 1100;
		_lvar_height = 800;
		_lvar_left = 100;
		_lvar_top = 100;
		_lvar_num = GEAnumero;
		_lvar_liq = GELid;
		_lvar_ant = GEAid;
		_lvar_conc = GECid;
		_lvar_viatico = GEAviatico;
		
		if(_VpopUpWin) {
			if(!_VpopUpWin.closed) _VpopUpWin.close();
		}
		_VpopUpWin = open('/cfmx/sif/tesoreria/GestionEmpleados/DetalleAnticipo.cfm?GECid='+_lvar_conc+'&GEAnumero='+_lvar_num+'&GELid='+_lvar_liq+'&GEAid='+_lvar_ant+'&GEAviatico='+_lvar_viatico+'', '_VpopUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+_lvar_width+',height='+_lvar_height+',left='+_lvar_left+', top='+_lvar_top+',screenX='+_lvar_left+',screenY='+_lvar_top+'');
	}	
</script>
