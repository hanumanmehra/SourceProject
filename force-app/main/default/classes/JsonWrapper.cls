public with sharing class JsonWrapper 
//public class JsonWrapper
{
	public String type;	//folder
	public String id;	//0
	public String name;	//All Files
	public Integer size;	//18897969
	public String item_status;	//active
	public cls_path_collection path_collection;
	public cls_item_collection item_collection;
	
	public class cls_path_collection
	{
		public Integer total_count;	//0
		public cls_entries[] entries;
	}
	public class cls_entries
	{
		public String type;	//file
		public String id;	//65926479057
		public String sequence_id;	//0
		public String etag;	//0
		public String sha1;	//2038e2ad1f8f9d869ac83eb39a24799a8bddd645     
		public String name;	//20160401_101905.jpg
	}
	public class cls_item_collection 
	{
		public Integer total_count;	//12  
		public cls_entries[] entries;
		public Integer offset;	//0
		public Integer limit1;	//100
	}
	public static JsonWrapper parse(String json)
	{
		return (JsonWrapper) System.JSON.deserialize(json, JsonWrapper.class); 
	}

	/*//Test code
	static testMethod void testParse() {
		String json=		'{'+
		'	"type": "folder",'+
		'	"id": "0",'+
		'	"sequence_id": null,'+
		'	"etag": null,'+
		'	"name": "All Files",'+
		'	"created_at": null,'+
		'	"modified_at": null,'+
		'	"description": "",'+
		'	"size": 18897969,'+
		'	"path_collection": {'+
		'		"total_count": 0,'+
		'		"entries": []'+
		'	},'+
		'	"created_by": {'+
		'		"type": "user",'+
		'		"id": "",'+
		'		"name": "",'+
		'		"login": ""'+
		'	},'+
		'	"modified_by": {'+
		'		"type": "user",'+
		'		"id": "278047877",'+
		'		"name": "Shyam Vaishnav",'+
		'		"login": "shyam@briskminds.com"'+
		'	},'+
		'	"trashed_at": null,'+
		'	"purged_at": null,'+
		'	"content_created_at": null,'+
		'	"content_modified_at": null,'+
		'	"owned_by": {'+
		'		"type": "user",'+
		'		"id": "278047877",'+
		'		"name": "Shyam Vaishnav",'+
		'		"login": "shyam@briskminds.com"'+
		'	},'+
		'	"shared_link": null,'+
		'	"folder_upload_email": null,'+
		'	"parent": null,'+
		'	"item_status": "active",'+
		'	"item_collection": {'+
		'		"total_count": 12,'+
		'		"entries": [{'+
		'			"type": "file",'+
		'			"id": "65926479057",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69306539325",'+
		'				"sha1": "2038e2ad1f8f9d869ac83eb39a24799a8bddd645"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "2038e2ad1f8f9d869ac83eb39a24799a8bddd645",'+
		'			"name": "20160401_101905.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66097171753",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69498444293",'+
		'				"sha1": "75e91ac826289b968faafb33d609a4f29ab46a86"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "75e91ac826289b968faafb33d609a4f29ab46a86",'+
		'			"name": "20160401_120641.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66120020113",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69523928525",'+
		'				"sha1": "326fe3de4c1bb747b9c67e03d7975b1eef77b7ce"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "326fe3de4c1bb747b9c67e03d7975b1eef77b7ce",'+
		'			"name": "20160401_163641.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66119836041",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69523723425",'+
		'				"sha1": "c22e925a3cc9885cb61b95d610f4ee78268d6e20"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "c22e925a3cc9885cb61b95d610f4ee78268d6e20",'+
		'			"name": "B612_20160402_093613.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66111124333",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69514008833",'+
		'				"sha1": "30b750e94277c04c4f8cd1877181bdd0015396ac"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "30b750e94277c04c4f8cd1877181bdd0015396ac",'+
		'			"name": "B612_20160402_180840.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "65733547709",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69090204121",'+
		'				"sha1": "28f614c1b31804faa911ec6ce6d2888603075393"'+
		'			},'+
		'			"sequence_id": "1",'+
		'			"etag": "1",'+
		'			"sha1": "28f614c1b31804faa911ec6ce6d2888603075393",'+
		'			"name": "IMG20160402150333.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66096985641",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69498239357",'+
		'				"sha1": "d35ae9ae7c54c9934804d64c1b80fef786360715"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "d35ae9ae7c54c9934804d64c1b80fef786360715",'+
		'			"name": "IMG20160403170935.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66096949101",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69498199013",'+
		'				"sha1": "6338dcaf4f763f838537e52278a935ecf717ec66"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "6338dcaf4f763f838537e52278a935ecf717ec66",'+
		'			"name": "IMG20160403181815.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66096911049",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69498156973",'+
		'				"sha1": "a0a30aa348f9a49570b918a2e10ba5e70559b344"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "a0a30aa348f9a49570b918a2e10ba5e70559b344",'+
		'			"name": "IMG20160403182732.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66096830349",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69498067965",'+
		'				"sha1": "5ddd8f2f17347c1b686d22c8927f0fa1bb236930"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "5ddd8f2f17347c1b686d22c8927f0fa1bb236930",'+
		'			"name": "IMG20160403191823.jpg"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66090920373",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69491611445",'+
		'				"sha1": "5206afdb69ca7fc57b3157a02cbc8ca860a81df4"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "5206afdb69ca7fc57b3157a02cbc8ca860a81df4",'+
		'			"name": "Resource Management.xlsx"'+
		'		}, {'+
		'			"type": "file",'+
		'			"id": "66093430653",'+
		'			"file_version": {'+
		'				"type": "file_version",'+
		'				"id": "69494343921",'+
		'				"sha1": "34cc06a794d3fd4c87813f86a20867b55e497659"'+
		'			},'+
		'			"sequence_id": "0",'+
		'			"etag": "0",'+
		'			"sha1": "34cc06a794d3fd4c87813f86a20867b55e497659",'+
		'			"name": "What is Salesforce.docx"'+
		'		}],'+
		'		"offset": 0,'+
		'		"limit": 100,'+
		'		"order": [{'+
		'			"by": "type",'+
		'			"direction": "ASC"'+
		'		}, {'+
		'			"by": "name",'+
		'			"direction": "ASC"'+
		'		}]'+
		'	}'+
		'}';
		JsonWrapper obj = parse(json);
		System.assert(obj != null);
	}*/
}