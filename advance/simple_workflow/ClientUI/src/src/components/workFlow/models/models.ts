    export interface Item {
      id: string;
      workflowId: string;
      numberOfRequestDays: string;
      startDate: string;
      requestForUser: string;
      comment: string;
      requester: string;
      currentState ? : any;
      executor: string;
      created: Date;
    }

    export interface WfItem {
      currentState: string;
      availableCommands: any[];
    }

    export interface WorkFlowDataItem {
      item: Item;
      wfItem: WfItem;
    }

    export interface User {
      id: string;
      userName: string;
      userRoles: string;
    }

    export interface Data {
      items: WorkFlowDataItem[];
      users: User[];
    }
