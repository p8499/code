package com.p8499.code;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Utils
{	public static String rept(String s,int t)
	{	StringBuffer sb=new StringBuffer();
		for(int i=0;i<t;i++)
			sb.append(s);
		return sb.toString();
	}
	@SuppressWarnings("unchecked")
	public static String join(Object s,String d)
	{	if(s.getClass().isArray())
			return String.join(d,(CharSequence[])s);
		else if(s instanceof List)
			return String.join(d,((List<String>)s).toArray(new String[((List<String>)s).size()]));
		else
			return null;
	}
	
	@SuppressWarnings("unchecked")
	public static Object lowerFirst(Object s)
	{	if(s instanceof String)
			return _lowerFirst((String)s);
		if(s instanceof String[])
			return _lowerFirstByArray((String[])s);
		else if(s instanceof Collection)
			return _lowerFirstByCollection((Collection<String>)s);
		else
			return null;
	}
	private static String _lowerFirst(String s)
	{	if(Character.isLowerCase(s.charAt(0)))
			return s;
		else
			return (new StringBuilder()).append(Character.toLowerCase(s.charAt(0))).append(s.substring(1)).toString();
	}
	private static String[] _lowerFirstByArray(String[] s)
	{	String[] result=new String[s.length];
		for(int i=0;i<result.length;i++)
			result[i]=_lowerFirst(s[i]);
		return result;
	}
	private static List<String> _lowerFirstByCollection(Collection<String> s)
	{	return Arrays.asList(_lowerFirstByArray(s.toArray(new String[s.size()])));
	}
	
	@SuppressWarnings("unchecked")
	public static Object upperFirst(Object s)
	{	if(s instanceof String)
			return _upperFirst((String)s);
		else if(s instanceof String[])
			return _upperFirstByArray((String[])s);
		else if(s instanceof Collection)
			return _upperFirstByCollection((Collection<String>)s);
		else
			return null;
	}
	private static String _upperFirst(String s)
	{	if(Character.isUpperCase(s.charAt(0)))
			return s;
		else
			return (new StringBuilder()).append(Character.toUpperCase(s.charAt(0))).append(s.substring(1)).toString();
	}
	private static String[] _upperFirstByArray(String[] s)
	{	String[] result=new String[s.length];
		for(int i=0;i<result.length;i++)
			result[i]=_upperFirst(s[i]);
		return result;
	}
	private static List<String> _upperFirstByCollection(Collection<String> s)
	{	return Arrays.asList(_upperFirstByArray(s.toArray(new String[s.size()])));
	}
	
	@SuppressWarnings("unchecked")
	public static Object upper(Object s)
	{	if(s instanceof String)
			return _upper((String)s);
		else if(s instanceof String[])
			return _upperByArray((String[])s);
		else if(s instanceof Collection)
			return _upperByCollection((Collection<String>)s);
		else
			return null;
	}
	private static String _upper(String s)
	{	return s.toUpperCase();
	}
	private static String[] _upperByArray(String[] s)
	{	String[] result=new String[s.length];
		for(int i=0;i<result.length;i++)
		{	result[i]=_upper(s[i]);
		}
		return result;
	}
	private static List<String> _upperByCollection(Collection<String> s)
	{	return Arrays.asList(_upperByArray(s.toArray(new String[s.size()])));
	}
	
	@SuppressWarnings("unchecked")
	public static Object lower(Object s)
	{	if(s instanceof String)
			return _lower((String)s);
		else if(s instanceof String[])
			return _lowerByArray((String[])s);
		else if(s instanceof Collection)
			return _lowerByCollection((Collection<String>)s);
		else
			return null;
	}
	private static String _lower(String s)
	{	return s.toLowerCase();
	}
	private static String[] _lowerByArray(String[] s)
	{	String[] result=new String[s.length];
		for(int i=0;i<result.length;i++)
		{	result[i]=_lower(s[i]);
		}
		return result;
	}
	private static List<String> _lowerByCollection(Collection<String> s)
	{	return Arrays.asList(_lowerByArray(s.toArray(new String[s.size()])));
	}
	
	public static List<Object> draw(Collection<Map<Object,Object>> objects,Object prop)
	{	return _drawByMap(objects,prop);
	}
	private static <K,T> List<T> _drawByMap(Collection<Map<K,T>> objects,K prop)
	{	List<T> result=new ArrayList<T>();
		for(Map<K,T> map:objects)
		{	if(map!=null)
				result.add(map.get(prop));
		}
		return result;
	}
	
	@SuppressWarnings("unchecked")
	public static Object sem(Object value,Collection<Map<Object,Object>> objects,Object prop)
	{	if(value.getClass().isArray())
			return _semByArray((Object[])value,objects,prop);
		if(value instanceof Collection)
			return _semByCollection((Collection<Object>)value,objects,prop);
		else
			return _sem(value,objects,prop);
	}
	private static <K,T> Map<K,T> _sem(T value,Collection<Map<K,T>> objects,K prop)
	{	for(Map<K,T> map:objects)
		{	if(map.get(prop).equals(value))
				return map;
		}
		return null;
	}
	@SuppressWarnings("unchecked")
	private static <K,T> Map<K,T>[] _semByArray(T[] values,Collection<Map<K,T>> objects,K prop)
	{	Map<K,T>[] results=(Map<K,T>[])Array.newInstance(values[0].getClass(),values.length);
		for(int i=0;i<values.length;i++)
		{	boolean found=false;
			for(Map<K,T> map:objects)
			{	if(map.get(prop).equals(values[i]))
				{	results[i]=map;
					found=true;
					break;
				}
			}
			if(!found)
				results[i]=null;
		}
		return results;
	}
	private static <K,T> List<Map<K,T>> _semByCollection(Collection<T> values,Collection<Map<K,T>> objects,K prop)
	{	List<Map<K,T>> results=new ArrayList<Map<K,T>>();
		for(T value:values)
		{	boolean found=false;
			for(Map<K,T> map:objects)
			{	if(map.get(prop).equals(value))
				{	results.add(map);
					found=true;
					break;
				}
			}
			if(!found)
				results.add(null);
		}
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public static Object seml(Object value,Collection<Map<Object,Collection<Object>>> objects,Object prop)
	{	if(value.getClass().isArray())
			return _semlByArray((Object[])value,objects,prop);
		if(value instanceof Collection)
			return _semlByCollection((Collection<Object>)value,objects,prop);
		else
			return _seml(value,objects,prop);
	}
	private static <K,T> Map<K,Collection<T>> _seml(T value,Collection<Map<K,Collection<T>>> objects,K prop)
	{	for(Map<K,Collection<T>> map:objects)
		{	if(map.get(prop).contains(value))
				return map;
		}
		return null;
	}
	@SuppressWarnings("unchecked")
	private static <K,T> Map<K,Collection<T>>[] _semlByArray(T[] values,Collection<Map<K,Collection<T>>> objects,K prop)
	{	Map<K,Collection<T>>[] results=(Map<K,Collection<T>>[])Array.newInstance(values[0].getClass(),values.length);
		for(int i=0;i<values.length;i++)
		{	boolean found=false;
			for(Map<K,Collection<T>> map:objects)
			{	if(map.get(prop).contains(values[i]))
				{	results[i]=map;
					found=true;
					break;
				}
			}
			if(!found)
				results[i]=null;
		}
		return results;
	}
	private static <K,T> List<Map<K,Collection<T>>> _semlByCollection(Collection<T> values,Collection<Map<K,Collection<T>>> objects,K prop)
	{	List<Map<K,Collection<T>>> results=new ArrayList<Map<K,Collection<T>>>();
		for(T value:values)
		{	boolean found=false;
			for(Map<K,Collection<T>> map:objects)
			{	if(map.get(prop).contains(value))
				{	results.add(map);
					found=true;
					break;
				}
			}
			if(!found)
				results.add(null);
		}
		return results;
	}
	
	@SuppressWarnings("unchecked")
	public static Object sel(Object value,Collection<List<Object>> objects)
	{	if(value.getClass().isArray())
			return _selByArray((Object[])value,objects);
		if(value instanceof Collection)
			return _selByCollection((Collection<Object>)value,objects);
		else
			return _sel(value,objects);
	}
	private static <T> List<T> _sel(T value,Collection<List<T>> objects)
	{	for(List<T> list:objects)
		{	if(list.contains(value))
				return list;
		}
		return null;
	}
	@SuppressWarnings("unchecked")
	private static <T> List<T>[] _selByArray(T[] values,Collection<List<T>> objects)
	{	List<T>[] results=(List<T>[])Array.newInstance(values[0].getClass(),values.length);
		for(int i=0;i<values.length;i++)
		{	boolean found=false;
			for(List<T> list:objects)
			{	if(list.contains(values[i]))
				{	results[i]=list;
					found=true;
					break;
				}
			}
			if(!found)
				results[i]=null;
		}
		return results;
	}
	private static <T> List<List<T>> _selByCollection(Collection<T> values,Collection<List<T>> objects)
	{	List<List<T>> results=new ArrayList<List<T>>();
		for(T value:values)
		{	boolean found=false;
			for(List<T> list:objects)
			{	if(list.contains(value))
				{	results.add(list);
					found=true;
					break;
				}
			}
			if(!found)
				results.add(null);
		}
		return results;
	}
	
	public static List<Object> union(Object param1,Object param2)
	{	return _union(param1,param2);
	}
	@SuppressWarnings("unchecked")
	private static List<Object> _union(Object...params)
	{	List<Object> result=new ArrayList<Object>();
		for(Object param:params)
		{	if(param.getClass().isArray())
				result.addAll(Arrays.asList((Object[])param));
			else if(param instanceof Collection)
				result.addAll((Collection<Object>)param);
			else
				result.add(param);
		}
		return result;
	}
	@SuppressWarnings("unchecked")
	public static List<Object> minus(Object param1,Object param2)
	{	List<Object> list1=new ArrayList<Object>();
		List<Object> list2=new ArrayList<Object>();
		if(param1.getClass().isArray())
			list1.addAll(Arrays.asList((Object[])param1));
		else if(param1 instanceof Collection)
			list1.addAll((Collection<Object>)param1);
		if(param2.getClass().isArray())
			list2.addAll(Arrays.asList((Object[])param1));
		else if(param2 instanceof Collection)
			list2.addAll((Collection<Object>)param1);
		list1.removeAll(list2);
		return list1;
	}
	@SuppressWarnings("unchecked")
	public static Object format1(String template,Object arg0)
	{	if(arg0 instanceof String)
			return String.format(template,arg0);
		else if(arg0.getClass().isArray())
			return _formatByArray(template,(String[])arg0);
		else if(arg0 instanceof List)
			return _formatByList(template,(List<String>)arg0);
		else
			return null;
	}
	@SuppressWarnings("unchecked")
	public static Object format2(String template,Object arg0,Object arg1)
	{	if(arg0 instanceof String)
			return String.format(template,arg0,arg1);
		else if(arg0.getClass().isArray())
			return _formatByArray(template,(String[])arg0,(String[])arg1);
		else if(arg0 instanceof List)
			return _formatByList(template,(List<String>)arg0,(List<String>)arg1);
		else
			return null;
	}
	@SuppressWarnings("unchecked")
	public static Object format3(String template,Object arg0,Object arg1,Object arg2)
	{	if(arg0 instanceof String)
			return String.format(template,arg0,arg1,arg2);
		else if(arg0.getClass().isArray())
			return _formatByArray(template,(String[])arg0,(String[])arg1,(String[])arg2);
		else if(arg0 instanceof List)
			return _formatByList(template,(List<String>)arg0,(List<String>)arg1,(List<String>)arg2);
		else
			return null;
	}
	private static String[] _formatByArray(String template,String[]...args)
	{	String[] result=new String[args[0].length];
		for(int i=0;i<args[0].length;i++)
		{	String[] arrString=_drawByArray(args,i);
			Object[] arrObject=new Object[arrString.length];
			for(int j=0;j<arrString.length;j++)
				arrObject[j]=arrString[j];
			result[i]=String.format(template,arrObject);
		}
		return result;
	}
	@SafeVarargs
	private static List<String> _formatByList(String template,List<String>...args)
	{	List<String> result=new ArrayList<String>();
		for(int i=0;i<args[0].size();i++)
		{	String[] arrString=_drawByList(args,i).toArray(new String[args.length]);
			Object[] arrObject=new Object[arrString.length];
			for(int j=0;j<arrString.length;j++)
				arrObject[j]=arrString[j];
			result.add(String.format(template,arrObject));
		}
		return result;
	}
	@SuppressWarnings("unchecked")
	private static <T> T[] _drawByArray(T[][] args,int index)
	{	T[] result=(T[])Array.newInstance(args[0][0].getClass(),args.length);
		for(int i=0;i<args.length;i++)
		{	result[i]=args[i][index];
		}
		return result;
	}
	private static <T> List<T> _drawByList(List<T>[] args,int index)
	{	List<T> result=new ArrayList<T>();
		for(int i=0;i<args.length;i++)
		{	result.add(args[i].get(index));
		}
		return result;
	}
	
	public static int length(int l)
	{	return _length(48,l,new int[]{0,16,64,256,1024},new int[]{16,64,256,1024,Integer.MAX_VALUE},new int[]{8,6,4,2,0});
	}
	private static int _length(int base,int l,int[] lows,int[] highs,int[] eachs)
	{	int result=0;
		for(int i=0;i<lows.length;i++)
		{	int low=lows[i];
			int high=highs[i];
			int within=l<low?0:l>high?high-low:l-low;
			result+=within*eachs[i];
		}
		return result>base?result:base;
	}
	public static void rel(Map<String,Object> fModel,Map<String,Object> dModel,Map<String,Object> relation)
	{	_domesticRel(fModel,dModel,relation);
		_foreignRel(fModel,dModel,relation);
	}
	@SuppressWarnings("unchecked")
	private static void _domesticRel(Map<String,Object> fModel,Map<String,Object> dModel,Map<String,Object> relation)
	{	List<Map<String,Object>> referencing=(List<Map<String,Object>>)((Map<String,Object>)dModel.get("mapper")).get("referencing");
		Map<String,Object> referencingItem=new LinkedHashMap<String,Object>();
		referencingItem.put("alias",relation.get("alias"));
		referencingItem.put("domestic",relation.get("domestic"));
		referencingItem.put("foreign",relation.get("foreign"));
		referencingItem.put("foreignModel",fModel);
		referencing.add(referencingItem);
	}
	@SuppressWarnings("unchecked")
	private static void _foreignRel(Map<String,Object> fModel,Map<String,Object> dModel,Map<String,Object> relation)
	{	String ids=((List<String>)relation.get("foreign")).toString();
		List<Map<String,Object>> referenced=(List<Map<String,Object>>)((Map<String,Object>)fModel.get("mapper")).get("referenced");
		Map<String,Object> referencedItem=null;
		for(Map<String,Object> r:referenced)
		{	String foreignIds=((List<String>)r.get("domestic")).toString();
			if(ids.equals(foreignIds))
			{	referencedItem=r;
				break;
			}
		}
		if(referencedItem==null)
		{	referencedItem=new LinkedHashMap<String,Object>();
			referencedItem.put("domestic",(List<String>)relation.get("foreign"));
			referencedItem.put("foreign",new ArrayList<Map<String,Object>>());
			referenced.add(referencedItem);
		}
		Map<String,Object> foreignItem=new LinkedHashMap<String,Object>();
		foreignItem.put("foreignModel",dModel);
		foreignItem.put("foreign",relation.get("domestic"));
		((List<Map<String,Object>>)referencedItem.get("foreign")).add(foreignItem);
	}
}
