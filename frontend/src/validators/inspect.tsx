// Helper function to validate if a value is an object
const isObject = (value: any): boolean => typeof value === 'object' && value !== null;

// Helper function to validate if a value is a string
const isString = (value: any): boolean => typeof value === 'string';

// Helper function to validate if a value is a number
const isNumber = (value: any): boolean => typeof value === 'number';

// Validate InspectHref
export const validateInspectHref = (data: any): boolean => {
    if (!isObject(data)) throw new Error("Invalid InspectHref: data is not an object");
    if (!isString(data.pathname)) throw new Error("Invalid InspectHref: pathname is not a string");
    if (!isObject(data.query)) throw new Error("Invalid InspectHref: query is not an object");
    if (!isString(data.query.model)) throw new Error("Invalid InspectHref: query.model is not a string");
    if (!(isNumber(data.query.id) || data.query.id === null)) throw new Error("Invalid InspectHref: query.id is not a number or null");
    if (!(isString(data.query.association) || data.query.association === null)) throw new Error("Invalid InspectHref: query.association is not a string or null");
    return true;
}

// Validate InspectHasMany
export const validateInspectHasMany = (data: any): boolean => {
    if (!isObject(data)) throw new Error("Invalid InspectHasMany: data is not an object");
    if (!isString(data.label)) throw new Error("Invalid InspectHasMany: label is not a string");
    if (!validateInspectHref(data.href)) throw new Error("Invalid InspectHasMany: href is invalid");
    if (!isString(data.model)) throw new Error("Invalid InspectHasMany: model is not a string");
    if (!isNumber(data.count)) throw new Error("Invalid InspectHasMany: count is not a number");

    if (Array.isArray(data.records)) {
        data.records.forEach((record: any) => {
            if (!validateInspectRecord(record)) throw new Error("Invalid InspectHasMany: record is invalid");
        });
    } else if (isObject(data.records)) {
        Object.values(data.records).forEach((record: any) => {
            if (!validateInspectRecord(record)) throw new Error("Invalid InspectHasMany: record is invalid");
        });
    } else {
        throw new Error("Invalid InspectHasMany: records is neither an array nor an object");
    }

    return true;
}

// Validate InspectRecord
export const validateInspectRecord = (data: any): boolean => {
    if (!isObject(data)) throw new Error("Invalid InspectRecord: data is not an object");
    if (!isNumber(data.id)) throw new Error("Invalid InspectRecord: id is not a number");
    if (!isObject(data.attributes)) throw new Error("Invalid InspectRecord: attributes is not an object");
    if (!isObject(data.belongs_to)) throw new Error("Invalid InspectRecord: belongs_to is not an object");
    if (!isObject(data.columns)) throw new Error("Invalid InspectRecord: columns is not an object");
    if (!isObject(data.has_many)) throw new Error("Invalid InspectRecord: has_many is not an object");
    if (!isObject(data.has_one)) throw new Error("Invalid InspectRecord: has_one is not an object");
    if (!isString(data.label)) throw new Error("Invalid InspectRecord: label is not a string");
    if (!isString(data.model)) throw new Error("Invalid InspectRecord: model is not a string");
    if (!validateInspectHref(data.href)) throw new Error("Invalid InspectRecord: href is invalid");

    Object.entries(data.attributes).forEach(([key, value]) => {
        if (!isString(key)) throw new Error("Invalid InspectRecord: attribute key is not a string");
    });

    Object.values(data.belongs_to).forEach((belongs_to: any) => {
        if (!validateInspectRecord(belongs_to)) throw new Error("Invalid InspectRecord: belongs_to record is invalid");
    });

    Object.values(data.columns).forEach((key, value) => {
        if (!isString(key)) throw new Error("Invalid InspectRecord: columns key is not a string");
        if (!isString(value)) throw new Error("Invalid InspectRecord: columns value is not a string");
    });

    Object.values(data.has_many).forEach((has_many: any) => {
        if (!validateInspectHasMany(has_many)) throw new Error("Invalid InspectRecord: has_many record is invalid");
    });

    Object.values(data.has_one).forEach((has_one: any) => {
        if (!validateInspectRecord(has_one)) throw new Error("Invalid InspectRecord: has_one record is invalid");
    });

    return true;
}